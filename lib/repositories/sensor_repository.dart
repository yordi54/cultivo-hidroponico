import 'package:firebase_database/firebase_database.dart';

import '../models/sensor_model.dart';

class SensorRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Sensor>> getAll() async {
    final DataSnapshot snapshot = await _database.child('sensors').get();
    List<Sensor> sensors = [];

    // Itera sobre los hijos del snapshot
    for (final child in snapshot.children) {
      // Obtiene los datos del sensor
      final Map<String, dynamic> data = toMap(child.value);

      // Crea un nuevo sensor a partir de los datos
      final Sensor sensor = Sensor.fromJson(data);
      // Agrega el sensor a la lista
      sensors.add(sensor);
    }

    // Devuelve la lista de sensores
    return sensors;
  }

  //crear un nuevo sensor
  Future<void> create(Sensor sensor) async {
    //generar un id para el sensor
    await _database.child('sensors').push().set(sensor.toJson());
    
  }

  Future<String> getSensorKey(String id) async {
    final DataSnapshot snapshot = await _database.child('sensors').get();

    // Itera sobre los hijos del snapshot
    for (final child in snapshot.children) {
      // Obtiene los datos del sensor
      final Map<String, dynamic> data = toMap(child.value);

      // Comprueba si el ID del sensor coincide
      if (data['id'] == id && (data['type'] == 'Temperatura' || data['type'] == 'Humedad' )) {
        // Devuelve la clave del sensor
        return child.key as String;
      }
    }

    // Si no se encuentra el sensor, devuelve null
    return '';
  }

   



  Map<String, dynamic> toMap<T>(Object? map) {
    return Map<String, dynamic>.from(map as Map);
  }
}