
import 'package:cultivo_hidroponico/repositories/dasboard_repository.dart';

class DashboardController {
  final DashboardRepository _repository = DashboardRepository();
  Future<List<Map<String,int>>> getTemperatura() async {
    final List<Map<String,int>> temp = await _repository.getTemperature();
    //update();
    List<Map<String, int>> reversedList = temp.map((map) {
      return Map.fromEntries(map.entries.toList().reversed);
    }).toList();
    return reversedList;
  }


  Future<List<Map<String,int>>> getTempHour() async{
    final List<Map<String,int>> temp = await _repository.getTempHour();
    return temp;
  }
}