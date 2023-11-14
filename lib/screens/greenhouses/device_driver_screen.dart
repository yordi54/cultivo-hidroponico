import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class DeviceDriverScreen extends StatefulWidget {

  DeviceDriverScreen({Key? key}) : super(key: key);

  @override
  State<DeviceDriverScreen> createState() => _DeviceDriverScreenState();
}

class _DeviceDriverScreenState extends State<DeviceDriverScreen> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  final int initialTimeInSeconds = 1 * 60;

   int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

 // 15 minutos en segundos
  bool isTimeUp = false;

  DateTime _selectedTime = DateTime.now();

  // @override
  // void initState() {
  //   super.initState();
  //   _stopWatchTimer.setPresetTime(mSec: initialTimeInSeconds);
  // }

  @override
  Widget build(BuildContext context) {
    final SensorController controller = Get.put(SensorController());
    return Scaffold(
      body: FutureBuilder<List<Sensor>>(
        future: controller.getAll(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return const Center(child: Text('Error'));
          }else {
            final List<Sensor> sensors = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: sensors.length,
                    itemBuilder: (context, index){
                      return Card(
                        color: Colors.greenAccent[100],
                        shadowColor: Colors.greenAccent[200],
                        elevation: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                SizedBox(
                                  width: 70,
                                  height: 100,
                                  child: Image.asset(
                                    '${sensors[index].icon}',
                                    color: Colors.white,
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${sensors[index].name}', style: const TextStyle(
                                      fontSize: 20, )),
                                    Text('Tipo : ${sensors[index].type}'),
                                    Text('Estado: ${sensors[index].state}'),
                                    Switch(
																	value: true,
																	onChanged: (value) {
																		// setState(() {
																		//   sensors[index].state = value;
																		//   sensorController.setValueEngine(value);
																		// });
																		print(value);
																	}
																),
                                    //icon para cambiar state
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: (){
                                  _showModalBottomSheet(context);
                                }, 
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined, 
                                  color: Colors.green,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      );
                    }
                  ),
                ),
                
              ],
            );
          }
        },
      ),
    );
  }

  _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0)
        )
      ),
      isScrollControlled: true,
      context: context, 
      builder: (constext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children:  [
                const Text(
                  "Motor de riego",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0,),
                const Divider(height: 5.0,),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque a sapien metus. Nam maximus sem ex, non fringilla diam luctus nec. Integer libero lorem",
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
                const SizedBox(height: 15.0,),
                const Divider(height: 5.0,),
                const Text(
                  "Cronograma",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15.0,),
                Row(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        _selectTime("Seleccionar encendido"),
                        const SizedBox(height: 10),
                        _selectTime("Seleccionar apagado"),
                        const SizedBox(height: 20),
                        StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snapshot) {
                            final value = snapshot.data!;
                            final remainingTimeInSeconds = _calculateTotalSeconds() - (value ~/ 1000);
                            final displayTime = _getDisplayTime(remainingTimeInSeconds);
                        
                            if (remainingTimeInSeconds <= 0 && !isTimeUp) {
                              isTimeUp = true;
                              print("Tiempo concluido");
                            }
                        
                            return Text(
                              displayTime,
                              style: const TextStyle(fontSize: 48),
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.setPresetTime(mSec: _calculateTotalSeconds());
                            _stopWatchTimer.onStartTimer();
                          },
                          child: Text('Iniciar'),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildTimeSelector(String label, int value, void Function(int?) onChanged) {
    return Column(
      children: [
        Text(label),
        SizedBox(height: 10),
        DropdownButton<int>(
          value: value,
          onChanged: onChanged,
          items: _buildDropdownItems(),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return List.generate(60, (index) {
      return DropdownMenuItem<int>(
        value: index,
        child: Text('$index'),
      );
    });
  }

  int _calculateTotalSeconds() {
    return (_selectedHours * 3600) + (_selectedMinutes * 60) + _selectedSeconds;
  }

  _selectTime(String label) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            showTimePicker(
              initialTime: TimeOfDay.fromDateTime(_selectedTime),
              context: context,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
          },
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18.0
            )
          ),
        ),
        const Text(
          "13H: 14M",
          style: TextStyle(
            fontSize: 18.0
          )
        )
      ],
    );
  }
  
  String _getDisplayTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}