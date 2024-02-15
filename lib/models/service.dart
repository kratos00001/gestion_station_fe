class Service {
  final int id;
  final String nom;
  final String description;

  Service({required this.id, required this.nom, required this.description});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
    );
  }
}
