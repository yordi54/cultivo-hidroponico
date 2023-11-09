

import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';

class DealerDataGridSource {

  final List<GreenHouseReport> _greenHouseReportData = [
    GreenHouseReport("En este invernadero el ph del agua bajo de nivel", "Invernadero 1", "2023-11-05", "12:00"),
    GreenHouseReport("Descripción 2", "Invernadero 1", "2023-11-05", "13:00"),
    GreenHouseReport("Descripción 3", "Invernadero 2", "2023-11-06", "14:00"),
    GreenHouseReport("Descripción 4", "Invernadero 1", "2023-11-07", "15:00"),
    GreenHouseReport("Descripción 5", "Invernadero 2", "2023-11-07", "16:00"),
  ];

  List<GreenHouseReport> get greenHouseReportData => _greenHouseReportData;
  
}