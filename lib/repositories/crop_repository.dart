import 'package:firebase_database/firebase_database.dart';
import '../models/crop_model.dart';

class CropRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Crop>> getAll() async {
    final DataSnapshot snapshot = await _database.child('crops').get();
    List<Crop> crops = [];

    // Itera sobre los hijos del snapshot
    for (final child in snapshot.children) {
      // Obtiene los datos del cultivo
      final Map<String, dynamic> data = toMap(child.value);

      // Crea un nuevo cultivo a partir de los datos
      final Crop crop = Crop.fromJson(data);
      // Agrega el cultivo a la lista
      crops.add(crop);
    }

    // Devuelve la lista de cultivos
    return crops;
  }


  //crear un nuevo cultivo
  Future<void> create(Crop crop) async {
    //generar un id para el cultivo
    await _database.child('crops').push().set(crop.toJson());
  }

  //get id de crop and return Crop
  Future<String> getCrop(String id) async {
    final DataSnapshot snapshot = await _database.child('crops').get();

    for (DataSnapshot child in snapshot.children) {
      final Map<String, dynamic> data = toMap(child.value);
      final Crop crop = Crop.fromJson(data);

      if (crop.id == id) {
        return crop.name.toString();
      }
    }

    return '';
  }

  Map<String, dynamic> toMap<T>(Object? map) {
    return Map<String, dynamic>.from(map as Map);
  }

  Future<Crop> getCropById(String id) async{
    final DataSnapshot snapshot = await _database.child('crops').get();

    for (DataSnapshot child in snapshot.children) {
      final Map<String, dynamic> data = toMap(child.value);
      final Crop crop = Crop.fromJson(data);

      if (crop.id == id) {
        return crop;
      }
    }
    return Crop(id: '', name: '', description: '', image: '');
  }
}