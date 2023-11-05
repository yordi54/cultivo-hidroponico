import 'package:cultivo_hidroponico/repositories/crop_repository.dart';
import 'package:get/get.dart';

import '../models/crop_model.dart';

class CropController extends GetxController {
  final CropRepository _repository = CropRepository();


  //create 
  Future<void> create(Crop crop) async {
    await _repository.create(crop);
  }

  // get all
   Future<List<Crop>> getAll() async {
    final List<Crop> crops = await _repository.getAll();
    update();
    return crops;
  }

  //get key of crop
  Future<String> getCrop(String  id) async {
    final String cropName  = await _repository.getCrop(id);
    update();
    return cropName;
  }
}