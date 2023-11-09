import 'package:cultivo_hidroponico/constants/list_plants.dart';
import 'package:cultivo_hidroponico/controllers/crop_controller.dart';
import 'package:cultivo_hidroponico/models/plant.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/crop_model.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({Key? key}) : super(key: key);

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _harvestTimeController = TextEditingController();
  Plant selectedPlant = Plant(name: '', imageUrl: '');
  final CropController controller = Get.put(CropController());
  

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Añadir Cultivo'),
        elevation: 3,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.greenAccent[200],
      ),
      body: 
      //formulario
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese un nombre para el cultivo';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre del cultivo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                //descripcion
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 10,
                  minLines: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese una descripción para el cultivo';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Descripción del cultivo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                // Tiempo de Cultivo en Dias
                TextFormField(
                  controller: _harvestTimeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese el tiempo de cultivo';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tiempo de cultivo',
                    hintText: 'Tiempo de cultivo en días',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                // images dropdown
                const SizedBox(height: 30,),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione una planta';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo Planta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  items: plants.map((plant){
                    return DropdownMenuItem(
                      value: plant,
                      child: Row(
                        children: [
                          Image.asset(plant.imageUrl, width: 50, height: 50, fit: BoxFit.contain ,),
                          const SizedBox(width: 10,),
                          Text(plant.name),
                        ],
                      ),
                    );   
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlant = value as Plant;
                    });
                  },
                ),
                

                // save boton
                const SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            // Validar el formulario
                            if (_formKey.currentState!.validate()) {
                              // Crear un objeto Crop con la información del formulario
                              final crop = Crop(
                                id: uuid.v4(),
                                name: _nameController.text,
                                description: _descriptionController.text,
                                image: selectedPlant.imageUrl,
                                harvestTime: int.parse(_harvestTimeController.text),
                              );
                              // Guardar el cultivo en la base de datos
                              controller.create(crop).then((value) => {
                                // Navegar a la pantalla anterior
                                Get.back()
                              },
                              onError: (error)  =>{
                                // Mostrar un mensaje de error
                                Get.snackbar('Error', 'Ocurrió un error al guardar el cultivo')
                              });
                            }
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: const Text('Guardar', style: TextStyle(fontSize: 20 ,color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}