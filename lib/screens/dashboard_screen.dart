import 'package:d_chart/commons/axis.dart';
import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/decorator.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:d_chart/commons/style.dart';
import 'package:d_chart/commons/viewport.dart';
import 'package:d_chart/numeric/line.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = DashboardController();
  List<OrdinalData> temp = [];
  List<OrdinalData> hum = [];
  List<NumericData> tempHour = [];
  List<NumericData> humHour = [];
  @override
  void initState() {
    super.initState();
    _controller.getTemperatura().then((value) => {
      setState(() {
        temp = value[0].entries.map((e) => OrdinalData(domain: convertirFechaADia(e.key), measure: e.value)).toList();
        hum = value[1].entries.map((e) => OrdinalData(domain: convertirFechaADia(e.key), measure: e.value)).toList();
      })
    });

    _controller.getTempHour().then((value) => {
      setState(() {
        tempHour = value[0].entries.map((e) => NumericData(domain: convertirHoraANumero(e.key), measure: e.value)).toList();
        humHour = value[1].entries.map((e) => NumericData(domain: convertirHoraANumero(e.key), measure: e.value)).toList();
      })
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    //_listen.cancel();

  }

  String convertirFechaADia(String fecha) {
    DateTime dateTime = DateTime.parse(fecha);
    String dayOfWeek = DateFormat('E', 'es_ES').format(dateTime);
    return dayOfWeek;
  }
  double convertirHoraANumero(String hora) {
    List<String> partes = hora.split(':');
    int horas = int.parse(partes[0]);
    int minutos = int.parse(partes[1]);
    // Convertir la hora a un número decimal (hora + minutos / 60)
    String horaDecimal = '$horas.$minutos';
    // Redondear a un decimal
    return double.parse(horaDecimal);
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width - 32.0; // 16.0 de padding en cada lado
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
        backgroundColor: Colors.greenAccent[200],
        ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              /* DATOS DE TEMPERATURA , CHART BAR */
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Datos Temperatura últimos 7 dias',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: DChartBarO(
                            measureAxis: const MeasureAxis(
                              showLine: true,
                            ),
                            animate: true,
                            outsideBarLabelStyle: (group, ordinalData, index) {
                              return const LabelStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                              );
                            
                            },
                            barLabelDecorator: BarLabelDecorator(
                              barLabelPosition: BarLabelPosition.outside,
                            ),
                            barLabelValue: (group, ordinalData, index) {
                              String measure = ordinalData.measure.round().toString();
                              return '$measure °C';
                            },

                            groupList: [
                              OrdinalGroup(
                                color: Colors.deepOrangeAccent[200],
                                id: '1',
                                chartType: ChartType.bar,
                                data: temp
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        
                        
                      ],
                    ),
                  ),
                ),
              ),

              //SizedBox(height: 16.0,),
              /* DATOS DE HUMEDAD , CHART BAR */
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Datos Humedad últimos 7 dias',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: DChartBarO(
                            measureAxis: const MeasureAxis(
                              showLine: true,
                            ),
                            animate: true,
                            barLabelDecorator: BarLabelDecorator(
                              barLabelPosition: BarLabelPosition.outside,
                            ),
                            barLabelValue: (group, ordinalData, index) {
                              String measure = ordinalData.measure.round().toString();
                              return '$measure %';
                            },
                            outsideBarLabelStyle: (group, ordinalData, index) {
                              return const LabelStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                              );
                            
                            },
                            groupList: [
                              OrdinalGroup(
                                color: Colors.deepOrangeAccent[200],
                                id: '2',
                                chartType: ChartType.bar,
                                data: hum,
                              ),
                            ],
                          ),
                        ),  
                      ],
                    ),
                  ),
                ),
              ),
              /* DATOS DE GENERAL , LINE BAR */
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Datos Temperatura por Dia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: DChartLineN(
                            measureAxis: MeasureAxis(
                              showLine: true,
                              desiredTickCount: 5,
                              labelFormat: (measure) {
                                return '${measure!.round()}°C';
                              
                              },
                            ),
                            configRenderLine: ConfigRenderLine(includeArea: true),
                            /*domainAxis: const DomainAxis(
                              numericViewport: NumericViewport(0,24)
                            ),*/
                            animate: true,
                            barLabelDecorator: BarLabelDecorator(
                              barLabelPosition: BarLabelPosition.outside,
                            ),
                            barLabelValue: (group, ordinalData, index) {
                              String measure = ordinalData.measure.round().toString();
                              return '$measure %';
                            },
                            outsideBarLabelStyle: (group, ordinalData, index) {
                              return const LabelStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 15,
                              );
                            
                            },
                            groupList: [
                              NumericGroup(
                                  id: '1',
                                  chartType: ChartType.line,
                                  data: tempHour,
                              ),
                              
                            ],
                          ),
                        ),  
                      ],
                    ),
                  ),
                ),
              ),

              /* DATOS DE GENERAL , LINE BAR */
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Datos Humedad por Dia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: DChartLineN(
                            measureAxis: MeasureAxis(
                              showLine: true,
                              desiredTickCount: 5,
                              labelFormat: (measure) {
                                return '${measure!.round()}%';
                              
                              },
                            ),
                            configRenderLine: ConfigRenderLine(includeArea: true),
                            /*domainAxis: const DomainAxis(
                              numericViewport: NumericViewport(0,24)
                            ),*/
                            animate: true,
                            barLabelDecorator: BarLabelDecorator(
                              barLabelPosition: BarLabelPosition.outside,
                            ),
                            barLabelValue: (group, ordinalData, index) {
                              String measure = ordinalData.measure.round().toString();
                              return '$measure %';
                            },
                            outsideBarLabelStyle: (group, ordinalData, index) {
                              return const LabelStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 15,
                              );
                            
                            },
                            groupList: [
                              NumericGroup(
                                  id: '1',
                                  chartType: ChartType.line,
                                  data: humHour,
                              ),
                              
                            ],
                          ),
                        ),  
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
    );
  }
}