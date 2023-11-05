import 'package:cultivo_hidroponico/controllers/crop_controller.dart';
import 'package:cultivo_hidroponico/models/crop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'add_crop_screen.dart';

class CropScreen extends StatelessWidget {
  const CropScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CropController controller = Get.put(CropController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent[200],
        onPressed: (){
          //con getx se usa Get.to
          Get.to(const AddCropScreen());
        }, 
        child: const Icon(Iconsax.add, color: Colors.white,),
      ),
      body: FutureBuilder<List<Crop>>(
        future: controller.getAll(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return const Center(child: Text('Error'));
          }else {
            final List<Crop> crops = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: crops.length,
                    itemBuilder: (context, index) => 
                    Card(
                      elevation: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.asset(crops[index].image.toString(), width: 100, height: 100, fit: BoxFit.contain,),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${crops[index].name}', style: const TextStyle(
                              fontSize: 20,
                            ),),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tiempo Cosecha: ${crops[index].harvestTime} Dias '),
                            
                          ]
                        ),
                      
                        trailing:  IconButton(
                          onPressed: (){
                            
                          }, 
                          icon: const Icon(Iconsax.trash, color: Colors.red,),
                        ),
                      ),
                    ),
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