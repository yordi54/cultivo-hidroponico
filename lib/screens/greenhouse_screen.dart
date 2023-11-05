import 'package:cultivo_hidroponico/controllers/crop_controller.dart';
import 'package:cultivo_hidroponico/models/greenhouse_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/greenhouse_controller.dart';
import 'add_greenhouse_screen.dart';

class GreenHouseScreen extends StatelessWidget {
  const GreenHouseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GreenHouseController controller = Get.put(GreenHouseController());
    final CropController cropController = Get.put(CropController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent[200],
        onPressed: (){
          Get.to(() => const AddGreenHouseScreen());
        }, 
        child: const Icon(Iconsax.add, color: Colors.white,),
      ),
      body: FutureBuilder<List<GreenHouse>>(
        future: controller.getAll(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return const Center(child: Text('Error'));
          }else {
            final List<GreenHouse> greenhouses = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: greenhouses.length,
                    itemBuilder: (context, index){
                      return Card(
                        elevation: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.network('https://i.ibb.co/zsTf189/componente-hidroponico.png ', width: 100, height: 100, fit: BoxFit.contain,),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${greenhouses[index].name}'),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Capacidad: ${greenhouses[index].capacity} '),
                              FutureBuilder<String>(
                                future: cropController.getCrop(greenhouses[index].cropId!), 
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData){
                                    return Text('Cultivo: ${snapshot.data}');
                                  }else{
                                    return const Text('Cultivo: ');
                                  }
                                })
                              ),
                              Text('Estado: ${greenhouses[index].state}'),
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