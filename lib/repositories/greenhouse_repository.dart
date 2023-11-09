//con getxcontroller
import 'package:cultivo_hidroponico/models/greenhouse_model.dart';
import 'package:firebase_database/firebase_database.dart';

class GreenHouseRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<GreenHouse>> getAll() async {
    final DataSnapshot snapshot = await _database.child('greenhouses').get();
    List<GreenHouse> greenhouses = [];

    // Itera sobre los hijos del snapshot
    for (final child in snapshot.children) {
      // Obtiene los datos del invernadero
      final Map<String, dynamic> data = toMap(child.value);

      // Crea un nuevo invernadero a partir de los datos
      final GreenHouse greenhouse = GreenHouse.fromJson(data);
      // Agrega el invernadero a la lista
      greenhouses.add(greenhouse);
    }

    // Devuelve la lista de invernaderos
    return greenhouses;
    
  }

  //crear un nuevo invernadero
  Future<void> create(GreenHouse greenhouse) async {
    //generar un id para el invernadero
    await _database.child('greenhouses').push().set(greenhouse.toJson());
  }
  //set state
  Future<void> setState(String id, String state) async {
    String key = await getKey(id) ;
    await _database.child('greenhouses/$key').update(
      {'state': state} 
    );
  } 

  Map<String, dynamic> toMap<T>(Object? map) {
    return Map<String, dynamic>.from(map as Map);
  }

  Future<String> getGreenHouse(String id) async {
    final DataSnapshot snapshot = await _database.child('greenhouses').get();

    for (DataSnapshot child in snapshot.children) {
      final Map<String, dynamic> data = toMap(child.value);
      final GreenHouse greenHouse = GreenHouse.fromJson(data);

      if (greenHouse.id == id) {
        return greenHouse.name.toString();
      }
    }

    return '';
  }

  Future<String> getKey(String id) async {
    final DataSnapshot snapshot = await _database.child('sensors').get();

    // Itera sobre los hijos del snapshot
    for (final child in snapshot.children) {
      // Obtiene los datos del sensor
      final Map<String, dynamic> data = toMap(child.value);

      // Comprueba si el ID del sensor coincide
      if (data['id'] == id ) {
        // Devuelve la clave del sensor
        return child.key as String;
      }
    }

    // Si no se encuentra el sensor, devuelve null
    return '';
  }

} 