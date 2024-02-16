import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_service.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.781350, -5.820759); // Example center
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadStations();
  }

  Future<void> _loadStations() async {
    var stations = await ApiService().fetchStations();
    setState(() {
      _markers = stations
          .map((station) => Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.nom,
          snippet: station.adresse,
        ),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet), // Example for custom marker color
      ))
          .toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations Map', style: TextStyle(color: Colors.white)), // Adjust the title style if needed
        backgroundColor: Colors.deepPurple, // Adjust AppBar color to fit your theme
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _loadStations(), // Example action: Refresh stations
        child: Icon(Icons.refresh),
        backgroundColor: Colors.deepPurple, // Adjust FAB color to fit your theme
      ),
    );
  }
}
