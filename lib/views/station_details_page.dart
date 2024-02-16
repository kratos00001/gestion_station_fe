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

  Color _getFuelTypeColor(String typeCarburant) {
    switch (typeCarburant.toLowerCase()) {
      case 'diesel':
        return Colors.black;
      case 'essence':
        return Colors.green;
      default:
        return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Station Details', style: theme.textTheme.headline6),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Or your brand color
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300, // Enhanced for visual impact
              width: double.infinity,
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.station.nom,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  Text(widget.station.adresse, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  Text(widget.station.ville, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prices',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            ...prices.map((price) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: _getFuelTypeColor(price.typeCarburant),
                              child: Text(
                                '${price.typeCarburant}: ${price.prix} dh',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Services',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            ...services.map((service) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                service.nom,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
