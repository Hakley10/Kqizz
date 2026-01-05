class Country {
  final String id;
  final String name;
  final String capital;
  final String continent;
  final String flagImage;
  final String mapImage;

  Country({
    required this.id,
    required this.name,
    required this.capital,
    required this.continent,
    required this.flagImage,
    required this.mapImage,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      capital: json['capital'],
      continent: json['continent'],
      flagImage: json['flagImage'],
      mapImage: json['mapImage'],
    );
  }
}
