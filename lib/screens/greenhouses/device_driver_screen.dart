import 'dart:async';

import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/greenhouse_model.dart';
import 'package:cultivo_hidroponico/models/sensor_model.dart';
import 'package:cultivo_hidroponico/screens/greenhouses/show_device_driver_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceDriverScreen extends StatefulWidget {

  const DeviceDriverScreen({super.key, required this.greenHouse});
  final GreenHouse greenHouse;
  
  @override
  State<DeviceDriverScreen> createState() => _DeviceDriverScreenState();
}

class _DeviceDriverScreenState extends State<DeviceDriverScreen> {
  
  final SensorController controller = Get.put(SensorController());

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final SensorController controller = Get.put(SensorController());
    return Scaffold(
      body: FutureBuilder<List<Sensor>>(
        future: controller.getSensorByGreenHouse(widget.greenHouse.id!, 'Controlador'),
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
                                    Text(
                                      '${sensors[index].name}',
                                      style: const TextStyle(
                                      fontSize: 20, )
                                    ),
                                    Text('Tipo : ${sensors[index].type}'),
                                    Text('Estado: ${sensors[index].state}'),
                                    Switch(
                                      value: sensors[index].state!,
                                      onChanged: (value) {
                                        setState(() {
                                          sensors[index].state = value;
                                          controller.setValueEngine("state", value);
                                          print(value);
                                        });
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
                                  Get.to(ShowDeviceDriverScreen(sensor: sensors[index],));
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

}