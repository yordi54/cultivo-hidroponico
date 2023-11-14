import 'package:cultivo_hidroponico/controllers/crop_controller.dart';
import 'package:cultivo_hidroponico/models/greenhouse_model.dart';
import 'package:cultivo_hidroponico/screens/greenhouses/show_greenhouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/greenhouse_controller.dart';
import 'add_greenhouse_screen.dart';

class GreenHouseScreen extends StatelessWidget {
  const GreenHouseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GreenHouseController controller = Get.put(GreenHouseController());
    final CropController cropController = Get.put(CropController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[200],
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
                        color: Colors.greenAccent[100],
                        shadowColor: Colors.greenAccent[200],
                        elevation: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            const SizedBox(width: 10,),
                            SizedBox(
                              width: 70,
                              height: 100,
                              child: Image.asset(
                                'assets/images/icons8-invernadero-48.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${greenhouses[index].name}', style: const TextStyle(
                                  fontSize: 20, )),
                                Text('Capacidad : ${greenhouses[index].capacity}'),
                                Text('Area: ${greenhouses[index].area}'),
                                Text('Estado: ${greenhouses[index].state}'),
                                FutureBuilder<String>(
                                  future: cropController.getCrop(greenhouses[index].cropId!), 
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData){
                                      print(snapshot);
                                      return Text('Cultivo: ${snapshot.data}');
                                    }else{
                                      return const Text('Cultivo: Error ');
                                    }
                                  })
                                ),
                              ],
                            ),
                            const SizedBox(width: 40,),
                            Column(
																children: [
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
																IconButton(
																	onPressed: (){
																		//openDialog(context, greenhouses[index].id!, greenhouses[index].state!, controller );
																	}, 
																	icon: const Icon(
																		Iconsax.edit, 
																		color: Colors.green,
																		size: 40.0,
																	),
																),
																IconButton(
																	onPressed: (){
																		Get.to(() => ShowGreenHouseScreen(greenHouse: greenhouses[index]));
																	}, 
																	icon: Icon(
																		Iconsax.eye, 
																		color: Colors.blue[400],
																		size: 40.0,
																	),
																),
															],
														)
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

    //show dialog change state function
    void openDialog(BuildContext context, String id, bool state, GreenHouseController controller){
      final String stateChange =  state ? 'Inhabilitado': 'Habilitado'; 
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Cambiar Estado'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Estas seguro de cambia a estado $stateChange?'),

                ],
              ) 
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    onPressed: (){
                      Get.back();
                    },
                    child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    onPressed: (){
                      controller.setState(id,state);
                      Get.back();
                    }, 
                    child: const Text('Aceptar', style: TextStyle(color: Colors.white),)
                  )
                ],
              ),
            ],
          );
        }
      );
    }
  
}