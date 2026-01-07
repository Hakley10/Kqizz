class Animal {
  final String id;
  final String name;
  final String image;

  Animal({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
