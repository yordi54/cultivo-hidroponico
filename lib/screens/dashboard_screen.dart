
/*import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Crea una referencia a la base de datos
  final database = FirebaseDatabase.instance.ref();
  int data = 0;

  @override
  void initState() {
    super.initState();
    final sensorRef = FirebaseDatabase.instance.ref().child('/sensors/-NiWH0fKyDWKgcWXzYnl/value');
    // Escucha los cambios en la base de datos
    sensorRef.onValue.listen((event) {
      setState(() {
        // Obtiene el valor del contador
        final value = event.snapshot.value;
        // Comprueba si el valor es un número
        if (value is int) {
          // Actualiza el valor del contador
          data = value;
        }
      
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('value: ${data.toString()}'),
      
      ),
    );
  }
}*/


import 'dart:async';

import 'package:cultivo_hidroponico/controllers/greenhouse_controller.dart';
import 'package:cultivo_hidroponico/controllers/report_controller.dart';
import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/greenhouse_model.dart';
import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';
import 'package:cultivo_hidroponico/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/sensor_model.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GreenHouseController greenHouseController = Get.put(GreenHouseController());
  final SensorController sensorController = Get.put(SensorController());
  List<GreenHouse> greenhouses = [];
  GreenHouse selectedGreenhouse = GreenHouse(name: '', image: '');
  List<Sensor> sensors = [];
  final sensorRef = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _listen;
  ReportController _reportController = ReportController();


  @override
  void initState() {
    super.initState();
    greenHouseController.getAll().then((value) {
      setState(() {
        greenhouses = value;
      });
    });

    //sensors
    _listen = sensorRef.child('/sensors').onValue.listen((event) {
      setState(() {
        // Obtiene el valor del contador
        final data = event.snapshot.value as Map;
        // Comprueba si el valor es un número
        for( int index = 0; index < sensors.length; index++  ){
          sensorController.getSensorKey(sensors[index].id.toString()).then((value) {
            if(data[value] != null){
              // Actualiza el valor del contador segun id
              //print(data[value]['value']),
              sensors[index].setValue(data[value]['value']);
              
              var now = DateTime.now();
              var formatter = DateFormat('yyyy-MM-dd');
              String formattedDate = formatter.format(now);
              String formattedTime = DateFormat.Hms().format(now);

              final greenHouseReport = {
                "description": "La ${data[value]['type']} es mayor de lo normal",
                "greenhouse": "Invernadero21",
                "date": formattedDate,
                "hour": formattedTime
              };

              if(data[value]['value'] > data[value]['max']){ //Verifica si es mayor al max
                _reportController.create(greenHouseReport);
              }
            }

          });
          
        }
        
      
      
      });
     });
  }

  @override
  void dispose() {
    super.dispose();
    _listen.cancel();

  }

  /*void _subscribeToSensorValue( List<Sensor> sensors){
    for (var index = 0; index < sensors.length; index++) {
      String key = '';
      sensorController.getSensorKey(sensors[index].id.toString()).then((value) {
        key = value;
      });
      final sensorRef = FirebaseDatabase.instance.ref().child('/sensors/$key/value');
      sensorRef.onValue.listen((event) {
        setState(() {
        // Obtiene el valor del contador
        final value = event.snapshot.value;
        // Comprueba si el valor es un número
        if (value is int) {
          // Actualiza el valor del contador
          sensors[index].setValue(value);
        }
      
      });
        
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Dashboard'),
        elevation: 3,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.deepOrangeAccent[200],
        ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          
              DropdownButtonFormField(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const InputDecoration(
                  labelText: 'Invernadero',
                  hintText: 'Seleccione un invernadero',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                ),
            
                items: greenhouses.map((greenhouse) => DropdownMenuItem(
                  value: greenhouse,
                  child: Text(greenhouse.name.toString()),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGreenhouse = value as GreenHouse;
                  });
                  sensorController.getSensorByGreenHouse(selectedGreenhouse.id.toString()).then((value) {
                    setState(() {
                      sensors = value;
                    });
                  });
                  
                },
            
          ),

          const SizedBox(height: 30,),
          Expanded(
            
                  child: ListView.builder(
                    itemCount: sensors.length,
                    itemBuilder: (context, index){
                      if(sensors[index].type == 'Temperatura'){
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          elevation: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Image.asset('${sensors[index].icon}', width: 100, height: 100, fit: BoxFit.contain,),
                                Text('${sensors[index].name}:'),
                                const SizedBox(width: 10,),
                                Text('${sensors[index].value} C°'),
                                //Switch(value: sensors[index].state == 'true', onChanged: (v){}),
                              ],
                            ),
                          ),
                        );
                      } else if(sensors[index].type == 'Humedad'){
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            elevation: 7,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Image.asset('${sensors[index].icon}', width: 100, height: 100, fit: BoxFit.contain,),
                                  Text('${sensors[index].name}:'),
                                  const SizedBox(width: 10,),
                                  Text('${sensors[index].value} %'),
                                  //Switch(value: sensors[index].state == 'true', onChanged: (v){}),
                                ],
                              ),
                            ),
                          );
                      }else {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          elevation: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Image.asset('${sensors[index].icon}', width: 100, height: 100, fit: BoxFit.contain,),
                                Text('${sensors[index].name}'),
                                const SizedBox(width: 30,),
                                Switch(value: sensors[index].state.toString().parseBool(), onChanged: (value){
                                  setState(() {
                                    sensors[index].state = value;
                                    sensorController.setValueEngine(value);
                                  });
                                  print(sensors[index].state);
                                }),
                              ],
                            ),
                          ),
                        );
                      }
                      
                    }
                  ),
                ),
          
        ],
      ),
    );
  }
}