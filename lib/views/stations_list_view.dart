import 'package:flutter/material.dart';
import 'package:gestion_station/views/station_details_page.dart';
import '../models/station.dart';
import '../services/api_service.dart';

class StationsListView extends StatefulWidget {
  @override
  _StationsListViewState createState() => _StationsListViewState();
}

class _StationsListViewState extends State<StationsListView> {
  late Future<List<Station>> futureStations;

  @override
  void initState() {
    super.initState();
    futureStations = ApiService().fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations List'),
      ),
      body: FutureBuilder<List<Station>>(
        future: futureStations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<Station>? stations = snapshot.data;
            return ListView.builder(
              itemCount: stations!.length,
              itemBuilder: (context, index) {
                Station station = stations[index];
                return ListTile(
                  title: Text(station.nom),
                  subtitle: Text(station.adresse),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StationDetailsPage(station: station),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
