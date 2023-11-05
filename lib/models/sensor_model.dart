class Sensor {
  final String? id;
  final String? name;
  final String? description;
  final String? state;
  final int? min;
  final int? max;
  final int? value;
  final String? icon;
  final String? greenhouseId;

  Sensor({
    this.id,
    this.name,
    this.description,
    this.state,
    this.min,
    this.max,
    this.value,
    this.icon,
    this.greenhouseId,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      state: json['state'],
      min: json['min'],
      max: json['max'],
      value: json['value'],
      icon: json['icon'],
      greenhouseId: json['greenhouseId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'state': state,
    'min': min,
    'max': max,
    'value': value,
    'icon': icon,
    'greenhouseId': greenhouseId,
  };
}