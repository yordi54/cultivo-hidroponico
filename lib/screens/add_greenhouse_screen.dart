
import 'package:cultivo_hidroponico/controllers/crop_controller.dart';
import 'package:cultivo_hidroponico/controllers/greenhouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/crop_model.dart';
import '../models/greenhouse_model.dart';

class AddGreenHouseScreen extends StatefulWidget {
  const AddGreenHouseScreen({Key? key}) : super(key: key);

  @override
  State<AddGreenHouseScreen> createState() => _AddCropScreenState();


}

class _AddCropScreenState extends State<AddGreenHouseScreen> {
  final uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();
  final CropController cropController = Get.put(CropController());
  final GreenHouseController controller = Get.put(GreenHouseController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<Crop> crops = [];
  Crop selectedCrop = Crop(id: '', name: '', image: '', harvestTime: 0);
  @override
  void initState() {
    super.initState();
    cropController.getAll().then((value) => {
      setState(() {
        crops.addAll(value);
      })
    },
    onError: (error){
      Get.snackbar('Error', 'Error al cargar los cultivos');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _areaController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Añadir Invernadero'),
        elevation: 3,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent[200],
      ),
      body: //formulario
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
                      return 'Ingrese un nombre para el invernadero';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre del invernadero',
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
                      return 'Ingrese una descripción para el invernadero';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Descripción del invernadero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                // Tiempo de Cultivo en Dias
                TextFormField(
                  controller: _areaController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese el area del invernadero';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Area (mts2)',
                    hintText: 'Area del invernadero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                // capacidad
                 TextFormField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese la capacidad del invernadero';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Capacidad (unidades)',
                    hintText: 'Capacidad del invernadero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                //location
                 TextFormField(
                  controller: _locationController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese la direccion del invernadero';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Direccion',
                    hintText: 'Direccion del invernadero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un cultivo';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Cultivo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  items: crops.map((crop) {
                    return DropdownMenuItem(
                      value: crop,
                      child: Row(
                        children: [
                          Text(crop.name.toString()),
                        ],
                      ),
                    );   
                  }).toList(),
                  onChanged: (value) {
                    selectedCrop = value as Crop;
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
                              // Crear un objeto  con la información del formulario
                              final greenhouse = GreenHouse(
                                id: uuid.v4(),
                                name: _nameController.text,
                                description: _descriptionController.text,
                                area: int.parse(_areaController.text),
                                capacity: int.parse(_capacityController.text),
                                location: _locationController.text,
                                cropId: selectedCrop.id,
                                state: true,
                                image: ''
                              );
                              // Agregar el cultivo a la base de datos
                              controller.create(greenhouse).then((value) => {
                                Get.back()
                              },
                              onError: (error){
                                Get.snackbar('Error', 'Error al crear el invernadero');
                              });
                              
                            }
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent[200],
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
