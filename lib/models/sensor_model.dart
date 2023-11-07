class Sensor {
  String? id;
  String? name;
  String? description;
  String? state;
  int? min;
  int? max;
  int? value;
  String? icon;
  String? greenhouseId;
  String? type;

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
    this.type,
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
      type: json['type'],
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
    'type': type,
  };

  //set value 
  void setValue(int value) {
    this.value = value;
  }
}