class Price {
  final int id;
  final String typeCarburant;
  final double prix;

  Price({required this.id, required this.typeCarburant, required this.prix});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'],
      typeCarburant: json['typeCarburant'],
      prix: json['prix'].toDouble(),
    );
  }
}
