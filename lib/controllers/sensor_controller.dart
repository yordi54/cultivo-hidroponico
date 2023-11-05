
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
}