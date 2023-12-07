

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class DashboardRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Map<String, int>>> getTemperature() async {
    final DataSnapshot snapshot = await _database.child('data').get();
    DateTime currentDate = DateTime.now();
    Map<String, int> last7Days = {};
    Map<String, int> last7Days2 = {};

    // Generar las fechas de los últimos 7 días
    for (int i = 0; i < 7; i++) {
      DateTime day = currentDate.subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(day);
      last7Days[formattedDate] = 0;
      last7Days2[formattedDate] = 0;
    }
    
    Map<String, int> tempCount = {}; 
    Map<String, int> humCount = {};

    for (final child in snapshot.children) {
      // Obtiene los datos del cultivo
      final Map<String, dynamic> data = toMap(child.value);

      if (data['sensor'] == 'temperatura' ) {
        // Crea un nuevo cultivo a partir de los datos
        final String date = data['date'];
        // Agrega el cultivo a la lista
        if( last7Days.containsKey(date)){
          last7Days[date] = (last7Days[date] ?? 0) + (data['value'] as int);
          tempCount[date] = (tempCount[date] ?? 0) + 1;
        }
      } else if(data['sensor'] == 'humedad'){
        final String date = data['date'];
        // Agrega el cultivo a la lista
        if( last7Days2.containsKey(date)){
          last7Days2[date] = (last7Days2[date] ?? 0) + (data['value'] as int);
          humCount[date] = (humCount[date] ?? 0) + 1;
        }
      }
      
    }
    for (final key in last7Days.keys) {
      last7Days[key] = last7Days[key] == 0 ? 0 : last7Days[key]! ~/ tempCount[key]!; 
      last7Days2[key] = last7Days2[key] == 0 ? 0 : last7Days2[key]! ~/ humCount[key]!;
    }
    // Devuelve la lista de cultivos
    //hacer reversa de la lista
    
    return [last7Days,last7Days2];
  }

  ///get por hora
  Future<List<Map<String, int>>> getTempHour() async{
    final DateTime currentDate = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    final DataSnapshot snapshot = await _database
      .child('data')
      .get();

    Map<String, int> result = {};
    Map<String, int> result2 = {};

    for( final child in snapshot.children){
      final Map<String, dynamic> data = toMap(child.value);
      if(data['sensor'] == 'temperatura'){
        final String date = data['date'];
        if(formattedDate.contains(date)){
          final String hour = data['hour'];
          result[hour] = data['value'];
        }
      }else if(data['sensor'] == 'humedad'){
        final String date = data['date'];
        if(formattedDate.contains(date)){
          final String hour = data['hour'];
          result2[hour] = data['value'];
        }

      }
    }
    return [result,result2];
  }

  Map<String, dynamic> toMap<T>(Object? map) {
    return Map<String, dynamic>.from(map as Map);
  }

  /* Listar todos los reportes */
 

}