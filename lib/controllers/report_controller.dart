import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';
import 'package:cultivo_hidroponico/repositories/report_repository.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final ReportRepository _repository = ReportRepository();

  Future<void> create(dynamic greenHouseReport) async {
    await _repository.create(greenHouseReport);
  }

  // get all
  Future<List<GreenHouseReport>> getAll() async {
    final List<GreenHouseReport> greenHouseReports = await _repository.getAll();
    update();
    return greenHouseReports;
  }

  Future<List<GreenHouseReport>> fetchFirstList() async {
    final List<GreenHouseReport> greenHouseReports = await _repository.fetchFirstList();
    return greenHouseReports;
  }

  Future<List<GreenHouseReport>> fetchNextReport() async {
    final List<GreenHouseReport> greenHouseReports = await _repository.fetchNextReport();
    return greenHouseReports;
  }

  Future<List<GreenHouseReport>> searchDocumentsByGreenHouse(String greenHouse) async {
    final List<GreenHouseReport> greenHouseReports = await _repository.searchDocumentsByGreenHouse(greenHouse);
    return greenHouseReports;
  }
}