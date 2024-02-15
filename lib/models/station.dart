import 'price.dart';
import 'service.dart';

class Station {
  final int id;
  final String nom;
  final String logoUrl;
  final String adresse;
  final String codePostal;
  final String ville;
  final double latitude;
  final double longitude;
  List<Price> prices;
  List<Service> services;

  Station({
    required this.id,
    required this.nom,
    required this.logoUrl,
    required this.adresse,
    required this.codePostal,
    required this.ville,
    required this.latitude,
    required this.longitude,
    this.prices = const [],
    this.services = const [],
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      nom: json['nom'],
      logoUrl: json['logoUrl'],
      adresse: json['adresse'],
      codePostal: json['codePostal'],
      ville: json['ville'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}
