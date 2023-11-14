import 'dart:async';

import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/sensor_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../controllers/report_controller.dart';
import '../../models/greenhouse_model.dart';

class DeviceMonitoringScreen extends StatefulWidget {
  const DeviceMonitoringScreen({super.key, required this.greenHouse}) ;
  final GreenHouse greenHouse;
  @override
  State<DeviceMonitoringScreen> createState() => _DeviceMonitoringScreenState();
}

class _DeviceMonitoringScreenState extends State<DeviceMonitoringScreen> {
  final SensorController controller = Get.put(SensorController());
  List<Sensor> sensors = [];
  late StreamSubscription<DatabaseEvent> _listen;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  final sensorRef = FirebaseDatabase.instance.ref();
  ReportController reportController = ReportController();
  @override
  void initState() {
    super.initState();
    controller.getSensorByGreenHouse(widget.greenHouse.id!, 'Sensor').then((value) => {
      setState(() {
        sensors = value;
      }),
    });
    
    //sensors
    _listen = sensorRef.child('/sensors').onValue.listen((event) {
      setState(() {
        // Obtiene el valor del contador
        final data = event.snapshot.value as Map;
        // Comprueba si el valor es un número
        for( int index = 0; index < sensors.length; index++  ){
          controller.getSensorKey(sensors[index].id.toString()).then((value) {
            if(data[value] != null){
              // Actualiza el valor del contador segun id
              //print(data[value]['value']),
              sensors[index].setValue(data[value]['value']);
              

              //reporte
              var now = DateTime.now();
              var formatter = DateFormat('yyyy-MM-dd');
              String formattedDate = formatter.format(now);
              String formattedTime = DateFormat.Hms().format(now);

              final greenHouseReport = {
                "description": "La ${data[value]['type']} es mayor de lo normal",
                "greenhouse": "Invernadero31",
                "date": formattedDate,
                "hour": formattedTime
              };

              if(data[value]['value'] > data[value]['max']){ //Verifica si es mayor al max
                reportController.create(greenHouseReport);
              }
             
            }
          });
        }
      });
     });
  }

  @override
  void dispose() {
    _listen.cancel();
    _maxController.dispose();
    _minController.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                                //icon para cambiar state
                              ],
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              children: [
                                Text( '${sensors[index].value}${sensors[index].type != 'Humedad' ? '°C':'%'}', style: const TextStyle(
                                  fontSize: 20, )),
                              ],
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    _showModalBottomSheet(context, index);
                                  }, 
                                  icon: const Icon(Iconsax.setting, color: Colors.green, size: 30,)
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
            ),
    );
  }

  _showModalBottomSheet(BuildContext context, int index) {
    _minController.text = sensors[index].min.toString();
    _maxController.text = sensors[index].max.toString();
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0)
        )
      ),
      isScrollControlled: true,
      context: context, 
      builder: (constext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children:  [
                const Text(
                  "Configuracion",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0,),
                const Divider(height: 5.0,),
                 Text(
                  "configuracion de valores estandar del sensor de ${sensors[index].type}. Si el valor del sensor supera o baja de  estos rangos , se generará una reporte.",
                  style: const TextStyle(
                    fontSize: 16.0
                  ),
                ),
                const SizedBox(height: 15.0,),
                const Divider(height: 5.0,),
                Text(
                  "Sensor de ${sensors[index].type}",
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 15.0,),
                Column(
                  children: [
                    TextFormField(
                      controller: _maxController,
                      //definir un valor por defecto
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximo',
                        hintText: 'Valor maximo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    TextFormField(
                      controller: _minController,
                      //definir un valor por defecto
                      //initialValue: sensors[index].min.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minimo',
                        hintText: 'Valor minimo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        )
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      onPressed: (){
                        int min = int.parse(_minController.text);
                        int max = int.parse(_maxController.text);
                        controller.saveValues(sensors[index].id!,min , max).then((value) => {
                          //setstate
                          setState(() {
                            sensors[index].min = min;
                            sensors[index].max = max;

                          }),
                          //cerrar modal
                          Navigator.pop(context)
                          
                        });
                        //controller.setMinValue(_minController.text, sensors[index].id.toString());
                        //controller.setMaxValue(_maxController.text, sensors[index].id.toString());
                        //Navigator.pop(context);
                      }, 
                      child: const Text('Guardar', style: TextStyle(color: Colors.white),)
                    )
                  ],
                )

              ],
            ),
          ),
        );
      }
    );
  }
}