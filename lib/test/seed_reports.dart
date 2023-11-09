
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class SeedReports {
  
  //final DatabaseReference _database = FirebaseDatabase.instance.ref("reports");
  final CollectionReference _reports = FirebaseFirestore.instance.collection("reports");
  
  Future<void> run() async {
    final random = Random();
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 50; i++) {
      final description = 'Descripción $i';
      final greenhouse = 'Invernadero $i';
      
      final now = DateTime.now();
      final formattedDate = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';

      final hour = '${random.nextInt(24)}:${random.nextInt(60)}:${random.nextInt(60)}';

      final dataItem = {
        'description': description,
        'greenhouse': greenhouse,
        'date': formattedDate,
        'hour': hour,
      };
      await _reports.add(dataItem);
      print("reporte $i guardado");
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }
}