import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/station.dart'; // Make sure this model has all necessary fields
import '../services/api_service.dart'; // Your API service
import 'station_details_page.dart'; // Import the StationDetailsPage

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
      _markers = stations.map((station) => Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.nom,
          snippet: station.adresse,
          // When the infoWindow is tapped, navigate to the details page
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StationDetailsPage(station: station),
            ));
          },
        ),
      )).toSet();
    });
  }

  Future<void> _goToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    setState(() {
      _markers.add(
        Marker(
          // Provide a unique ID for the current location marker
          markerId: MarkerId("current_location"),
          position: currentLocation,
          infoWindow: InfoWindow(
            title: 'My Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), // Custom color
        ),
      );
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentLocation,
        zoom: 14.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: Text('My Location'),
        icon: Icon(Icons.location_searching),
      ),
    );
  }
}
