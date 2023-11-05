
class SensorImage {
  String imageUrl;
  String name;

  SensorImage({
    required this.imageUrl,
    required this.name,
  });

  factory SensorImage.fromJson(Map<String, dynamic> json) => SensorImage(
      imageUrl: json["imageUrl"],
      name: json["name"],
    );
      

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "name": name,
  };
}