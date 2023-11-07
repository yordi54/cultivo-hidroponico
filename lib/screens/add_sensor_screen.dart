
import 'package:cultivo_hidroponico/constants/list_sensor.dart';
import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/sensor_images_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/greenhouse_controller.dart';
import '../models/greenhouse_model.dart';
import '../models/sensor_model.dart';

class AddSensorScreen extends StatefulWidget {
  const AddSensorScreen({super.key});

  @override
  State<AddSensorScreen> createState() => _AddSensorScreenState();
}

class _AddSensorScreenState extends State<AddSensorScreen> {
  final uuid = const Uuid();
  final _formKey = GlobalKey<FormState>();
  SensorImage selectedSensor = SensorImage(imageUrl: '', name: '');
  final GreenHouseController greenhouseController = Get.put(GreenHouseController());
  final SensorController controller = Get.put(SensorController());
  final List<GreenHouse> greenhouses = [];
  GreenHouse selectedGreenhouse = GreenHouse(
    id: '',
    name: '',
    location: '',
    description: '',
    image: '',
    state: true,
    area: 0,
    capacity: 0,
    cropId: '',
  );
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    greenhouseController.getAll().then((value) => {
      setState(() {
        greenhouses.addAll(value);
      })
    },
    onError: (error) => {
      Get.snackbar('Error', 'Ocurrió un error al obtener los invernaderos')
    });
  }

  @override
  void dispose() {
    greenhouseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Añadir Sensor'),
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
      body: SingleChildScrollView(
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
                      return 'Ingrese un nombre para el sensor';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre del sensor',
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
                      return 'Ingrese una descripción para el sensor';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Descripción del sensor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                // Tiempo de Cultivo en Dias
                TextFormField(
                  controller: _minValueController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese el valor minimo del sensor';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Valor Mínimo',
                    hintText: 'Valor minimo del sensor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                ),
                // images dropdown
                const SizedBox(height: 30,),
                TextFormField(
                  controller: _maxValueController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingrese el valor maximo del sensor';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Valor Maximo',
                    hintText: 'Valor maximo del sensor',
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
                      return 'Seleccione un tipo de sensor';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo Sensor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  items: simages.map((simage){
                    return DropdownMenuItem(
                      value: simage,
                      child: Row(
                        children: [
                          Image.asset(simage.imageUrl, width: 50, height: 50, fit: BoxFit.contain,),
                          const SizedBox(width: 10,),
                          Text(simage.name),
                        ],
                      ),
                    );   
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSensor = value as SensorImage;
                    });
                  },
                ),
                // invernadero list
                const SizedBox(height: 30,),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un invernadero';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Invernadero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  items: greenhouses.map((greenhouse){
                    return DropdownMenuItem(
                      value: greenhouse,
                      child: Row(
                        children: [
                          Text(greenhouse.name.toString()),
                        ],
                      ),
                    );   
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGreenhouse = value as GreenHouse;
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
                              final sensor = Sensor(
                                id: uuid.v4(),
                                name: _nameController.text,
                                description: _descriptionController.text,
                                min: int.parse(_minValueController.text),
                                max: int.parse(_maxValueController.text),
                                icon: selectedSensor.imageUrl,
                                greenhouseId: selectedGreenhouse.id,
                                value: 0,
                                type: selectedSensor.name,
                              );
                              // Guardar el cultivo en la base de datos
                              controller.create(sensor).then((value) => {
                                Get.back()
                              },
                              onError: (error) => {
                                Get.snackbar('Error', 'Ocurrió un error al guardar el sensor')
                              }
                              );
                              
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