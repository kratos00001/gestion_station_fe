import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/price.dart';
import '../models/service.dart';
import '../models/station.dart';
import '../services/api_service.dart';

class StationDetailsPage extends StatefulWidget {
  final Station station;

  const StationDetailsPage({Key? key, required this.station}) : super(key: key);

  @override
  _StationDetailsPageState createState() => _StationDetailsPageState();
}

class _StationDetailsPageState extends State<StationDetailsPage> {
  late List<Price> prices;
  late List<Service> services;

  @override
  void initState() {
    super.initState();
    fetchPricesAndServices();
  }

  Future<void> fetchPricesAndServices() async {
    try {
      prices = await ApiService().fetchPricesForStation(widget.station.id);
      services = await ApiService().fetchServicesForStation(widget.station.id);
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Station Details'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.station.latitude, widget.station.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.station.id.toString()),
                    position: LatLng(widget.station.latitude, widget.station.longitude),
                    infoWindow: InfoWindow(
                      title: widget.station.nom,
                      snippet: widget.station.adresse,
                    ),
                  ),
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Station Name: ${widget.station.nom}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Address: ${widget.station.adresse}'),
                  SizedBox(height: 16),
                  Text(
                    'Prices:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: prices.map((price) {
                      return Text(
                        '${price.typeCarburant}: ${price.prix.toString()}€',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Services:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: services.map((service) {
                      return Text(
                        '- ${service.nom}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
