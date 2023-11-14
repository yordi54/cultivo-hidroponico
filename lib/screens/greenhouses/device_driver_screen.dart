import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/sensor_model.dart';
import 'package:cultivo_hidroponico/screens/greenhouses/show_device_driver_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceDriverScreen extends StatefulWidget {

  const DeviceDriverScreen({Key? key}) : super(key: key);

  @override
  State<DeviceDriverScreen> createState() => _DeviceDriverScreenState();
}

class _DeviceDriverScreenState extends State<DeviceDriverScreen> {
  
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
                                  //_showModalBottomSheet(context);
                                  Get.to(() => const ShowDeviceDriverScreen() );
                                  
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

  // _showModalBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(25.0)
  //       )
  //     ),
  //     isScrollControlled: false,
  //     context: context, 
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState){
  //           return Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: ListView(
  //               children:  [
  //                 const Text(
  //                   "Motor de riego",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 25.0,
  //                     fontWeight: FontWeight.bold
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10.0,),
  //                 const Divider(height: 5.0,),
  //                 const Text(
  //                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque a sapien metus. Nam maximus sem ex, non fringilla diam luctus nec. Integer libero lorem",
  //                   style: TextStyle(
  //                     fontSize: 16.0
  //                   ),
  //                 ),
  //                 const SizedBox(height: 15.0,),
  //                 const Divider(height: 5.0,),
  //                 const Text(
  //                   "Cronograma",
  //                   style: TextStyle(
  //                     fontSize: 25.0,
  //                     fontWeight: FontWeight.bold
  //                   ),
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     const SizedBox(height: 10),
  //                     Card(
  //                       elevation: 8.0,
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           children: [
  //                             const Text(
  //                               "Intervalo de tiempo",
  //                               style: TextStyle(
  //                                 fontSize: 18.0,
  //                                 fontWeight: FontWeight.bold
  //                               )
  //                             ),
  //                             _selectTime(
  //                               setState,
  //                               SelectedTime(hour: 0, minute: 0)
  //                             ),
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 _stopWatchTimer.onStopTimer();
  //                                 _stopWatchTimer.setPresetTime(mSec: _calculateTotalSeconds());
  //                                 _stopWatchTimer.onStartTimer();

  //                                 //Conversión y guardar
  //                               }, 
  //                               child: const Text(
  //                                 "Guardar intervalo",
  //                                 style: TextStyle(
  //                                   fontSize: 18.0,
  //                                   fontWeight: FontWeight.bold
  //                                 )
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox( height: 10.0,),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         _timeCard(
  //                           "Encendido",
  //                           background: _onSelected ? Colors.green: Colors.white,
  //                           colorLabel: _onSelected ? Colors.white: Colors.black
  //                         ),
  //                         _timeCard(
  //                           "Apagado",
  //                           background: _offSelected ? Colors.green: Colors.white,
  //                           colorLabel: _offSelected ? Colors.white: Colors.black
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 20),
  //                     StreamBuilder<int>(
  //                       stream: _stopWatchTimer.rawTime,
  //                       initialData: _stopWatchTimer.rawTime.value,
  //                       builder: (context, snapshot) {
  //                         final value = snapshot.data!;
  //                         final remainingTimeInSeconds = _calculateTotalSeconds() - (value ~/ 1000);
  //                         final displayTime = _getDisplayTime(remainingTimeInSeconds);
                      
  //                         if (remainingTimeInSeconds <= 0) {
  //                           _stopWatchTimer.onStopTimer();
  //                           print("Tiempo concluido");
  //                           if(_onSelected){
  //                           _onSelected = false;
  //                           _offSelected = true;
  //                           }else{
  //                             _onSelected = true;
  //                             _offSelected = false;
  //                           }
  //                           isTimeUp = true;
  //                         }
                      
  //                         return Text(
  //                           displayTime,
  //                           style: const TextStyle(fontSize: 48),
  //                         );
  //                       },
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           );
  //         }
  //       );
  //     }
  //   );
  // }

}