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
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations List'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
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
            return ListView.separated(
              itemCount: stations!.length,
              separatorBuilder: (context, index) => Divider(color: theme.dividerColor),
              itemBuilder: (context, index) {
                Station station = stations[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                        station.nom,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address: ${station.adresse}', style: theme.textTheme.subtitle1),
                          Text('City: ${station.ville}', style: theme.textTheme.subtitle1),
                        ],
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20, color: theme.primaryColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StationDetailsPage(station: station),
                        ),
                      );
                    },
                  ),
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
