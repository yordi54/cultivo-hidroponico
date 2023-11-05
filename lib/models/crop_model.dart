class Crop {
  final String? id;
  final String? name;
  final String? image;
  final String? description;
  final int? harvestTime;

  Crop({
    this.id,
    this.name,
    this.image,
    this.description,
    this.harvestTime,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      harvestTime: json['harvestTime'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'description': description,
    'harvestTime': harvestTime,
  };
}