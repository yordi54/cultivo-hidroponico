import 'package:cultivo_hidroponico/repositories/greenhouse_repository.dart';
import 'package:get/get.dart';

import '../models/greenhouse_model.dart';

class GreenHouseController extends GetxController {
  final GreenHouseRepository _repository = GreenHouseRepository();

  /*@override
  void onReady() {
    super.onReady();
    getAll();
    update();
  }*/

  // create 
  Future<void> create(GreenHouse greenhouse) async {

    await _repository.create(greenhouse);
  }

  // get all
   Future<List<GreenHouse>> getAll() async {
    final List<GreenHouse> greenhouses = await _repository.getAll();
    //update();
    return greenhouses;
  }

  //get key of crop
  Future<String> getGreenHouse(String  id) async {
    final String greenHouseName  = await _repository.getGreenHouse(id);
    
    return greenHouseName;
  }

  //set state
  Future<void> setState(String id, bool state) async {
    await _repository.setState(id, state);
  } 

}