class GreenHouseReport {
  final String description;
  final String greenhouse;
  final String date;
  final String hour;

  GreenHouseReport(this.description, this.greenhouse, this.date, this.hour);

  factory GreenHouseReport.fromJson(Map<String, dynamic> json) {
    final String description = json['description'];
    final String greenhouse = json['greenhouse'];
    final String date = json['date'];
    final String hour = json['hour'];

    return GreenHouseReport(description, greenhouse, date, hour);
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'greenhouse': greenhouse,
    'date': date,
    'hour': hour,
  };
}