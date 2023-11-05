class Plant {

  final String name;
  final String imageUrl;

  Plant({ required this.name, required this.imageUrl});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
  };
}