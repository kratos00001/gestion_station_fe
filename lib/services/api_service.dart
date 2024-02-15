import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station.dart';
import '../models/price.dart';
import '../models/service.dart';

class ApiService {
  final String _baseUrl = "http://localhost:8080/api";

  Future<List<Station>> fetchStations() async {
    final stationsResponse = await http.get(Uri.parse('$_baseUrl/stations'));
    if (stationsResponse.statusCode == 200) {
      List<dynamic> stationsJson = json.decode(stationsResponse.body);
      List<Station> stations = [];
      for (var stationJson in stationsJson) {
        Station station = Station.fromJson(stationJson);
        stations.add(station);
      }
      return stations;
    } else {
      throw Exception('Failed to load stations from API');
    }
  }

  Future<List<Price>> fetchPricesForStation(int stationId) async {
    final pricesResponse = await http.get(Uri.parse('$_baseUrl/price/station/$stationId'));
    if (pricesResponse.statusCode == 200) {
      List<dynamic> pricesJson = json.decode(pricesResponse.body);
      return pricesJson.map((priceJson) => Price.fromJson(priceJson)).toList();
    } else {
      throw Exception('Failed to load prices for station $stationId');
    }
  }

  Future<List<Service>> fetchServicesForStation(int stationId) async {
    final servicesResponse = await http.get(Uri.parse('$_baseUrl/service/station/$stationId'));
    if (servicesResponse.statusCode == 200) {
      List<dynamic> servicesJson = json.decode(servicesResponse.body);
      return servicesJson.map((serviceJson) => Service.fromJson(serviceJson)).toList();
    } else {
      throw Exception('Failed to load services for station $stationId');
    }
  }

}
