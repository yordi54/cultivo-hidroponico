
import 'package:cultivo_hidroponico/repositories/sensor_repository.dart';
import 'package:get/get.dart';

import '../models/sensor_model.dart';

class SensorController extends GetxController {
  final SensorRepository _repository = SensorRepository();

  @override
  void onReady() {
    super.onReady();
    update();
  }

  // create
  Future<void> create(Sensor sensor) async {
    await _repository.create(sensor);
  }

  // get all
  Future<List<Sensor>> getAll() async {
    final List<Sensor> sensors = await _repository.getAll();
    update();
    return sensors;
  }

  //get key of sensor
  Future<String> getSensorKey(String id) async {
    final String sensorKey = await _repository.getSensorKey(id);
    update();
    return sensorKey;
  }

  Future<List<Sensor>> getSensorByGreenHouse(String id) async {
    final List<Sensor> sensors = await _repository.getAll();
    final List<Sensor> sensorByGreenHouse = [];
    for (Sensor sensor in sensors) {
      if (sensor.greenhouseId == id) {
        sensorByGreenHouse.add(sensor);
      }
    }
    return sensorByGreenHouse;
  }
}