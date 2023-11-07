import 'package:cultivo_hidroponico/controllers/greenhouse_controller.dart';
import 'package:cultivo_hidroponico/models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/sensor_controller.dart';
import 'add_sensor_screen.dart';

class SensorScreen extends StatelessWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SensorController controller = Get.put(SensorController());
    final GreenHouseController greenHouseController = Get.put(GreenHouseController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent[200],
        onPressed: (){
          //con getx se usa Get.to
          Get.to(() => const AddSensorScreen());
          /* controller.getSensorKey('79a22941-c283-4fe3-ad21-00b266652e4d').then((value) => {
            print(value)
          },
          onError: (error) => {
            print(error)
          }
          ); */
        }, 
        child: const Icon(Iconsax.add, color: Colors.white,),
      ),
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
                        elevation: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.asset('${sensors[index].icon}', width: 100, height: 100, fit: BoxFit.contain,),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${sensors[index].name}'),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tipo: Temperatura'),
                              FutureBuilder<String>(
                                future: greenHouseController.getGreenHouse(sensors[index].greenhouseId!), 
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData){
                                    return Text('Invernadero: ${snapshot.data}');
                                  }else{
                                    return const Text('Invernadero: ');
                                  }
                                })
                              ),
                            ]
                          ),
                        
                          trailing:  IconButton(
                            onPressed: (){
                              
                            }, 
                            icon: const Icon(Iconsax.trash, color: Colors.red,),
                          ),
                        ),
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