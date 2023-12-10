class GreenHouseReport {
  final String description;
  final String greenhouse;
  final String date;
  final String hour;

  GreenHouseReport(this.description, this.greenhouse, this.date, this.hour);

  factory GreenHouseReport.fromJson(Map<String, dynamic> json) {
    return GreenHouseReport(
      json['description'],
      json['greenhouse'],
      json['date'],
      json['hour'],
    );
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'greenhouse': greenhouse,
    'date': date,
    'hour': hour,
  };
}