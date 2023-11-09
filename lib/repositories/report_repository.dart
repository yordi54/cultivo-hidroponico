import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';

class ReportRepository {
  final CollectionReference _reports = FirebaseFirestore.instance.collection("reports");
  late List<DocumentSnapshot> documentList;
  final int _limit = 10;

  Future<void> create(dynamic greenHouseReport) async {
    await _reports.add(greenHouseReport);
  }

  Future<List<GreenHouseReport>> getAll() async {
    QuerySnapshot querySnapshot = await _reports.get();
    return _convertDocumentToModel(querySnapshot.docs);
  }

  Future<List<GreenHouseReport>> fetchFirstList() async {
    try {
      QuerySnapshot querySnapshot = await _reports.orderBy("date").limit(_limit).get();
      documentList = querySnapshot.docs;

      return _convertDocumentToModel(documentList);
    } on SocketException {
      print(const SocketException("No Internet Connection"));
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<GreenHouseReport>> fetchNextReport() async {
    try {
      QuerySnapshot querySnapshot = await _reports.orderBy("date").startAfterDocument(documentList[documentList.length - 1]).limit(_limit).get();
      List<DocumentSnapshot> newDocumentList = querySnapshot.docs;
      documentList.addAll(newDocumentList);

      return _convertDocumentToModel(documentList);

    } on SocketException {
      print(const SocketException("No Internet Connection"));
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
  
  Future<List<GreenHouseReport>> searchDocumentsByGreenHouse(String greenHouse) async {
    QuerySnapshot querySnapshot = await _reports.where('greenhouse', isEqualTo: greenHouse).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    return _convertDocumentToModel(documents);
  }

  _convertDocumentToModel(List<DocumentSnapshot> snapshots) {

    List<GreenHouseReport> greenHouseReports = [];
    for (var data in snapshots) {
      GreenHouseReport greenHouseReport = GreenHouseReport.fromJson(
          {
            "description": data["description"],
            "greenhouse": data["greenhouse"],
            "date": data["date"],
            "hour": data["hour"],
          }
        );
        greenHouseReports.add(greenHouseReport);
    }

    return greenHouseReports;
  }

}