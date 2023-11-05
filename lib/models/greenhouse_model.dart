//model for greenhouse

class GreenHouse {
  final String? name;
  final String? location;
  final String? description;
  final String? image;
  final bool? state;
  final String? id;
  final int? area;
  final int? capacity;
  final String? cropId;

  GreenHouse({this.name, this.location, this.description, this.image, this.id, this.state, this.area, this.capacity, this.cropId});

  factory GreenHouse.fromJson(Map<String, dynamic> json) {
    return GreenHouse(
      name: json['name'],
      location: json['location'],
      description: json['description'],
      image: json['image'],
      id: json['id'],
      state: json['state'],
      area: json['area'],
      capacity: json['capacity'],
      cropId: json['cropId'],
    );
  }


  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
    'description': description,
    'image': image,
    'id': id,
    'state': state,
    'area': area,
    'capacity': capacity,
    'cropId': cropId,
  };
}