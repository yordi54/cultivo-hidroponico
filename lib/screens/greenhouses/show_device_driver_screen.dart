
import 'package:cultivo_hidroponico/controllers/sensor_controller.dart';
import 'package:cultivo_hidroponico/models/sensor_model.dart';
//import 'package:cultivo_hidroponico/screens/greenhouses/device_driver_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ShowDeviceDriverScreen extends StatefulWidget{
  Sensor sensor;
  ShowDeviceDriverScreen({super.key, required this.sensor});

  @override
  State<ShowDeviceDriverScreen> createState() => _ShowDeviceDriverScreenState();
}

class _ShowDeviceDriverScreenState extends State<ShowDeviceDriverScreen> {

  final SensorController controller = Get.put(SensorController());
  late StopWatchTimer _stopWatchTimer;

  // int _selectedHours = 0;
  // int _selectedMinutes = 0;
  // int _selectedSeconds = 0;
  bool isTimeUp = false;

  late int max;
  late bool state;
  late SelectedTime  _selectedTime;
  late SelectedTime _initialTime;

  late bool _onSelected;
  late bool _offSelected;

  @override
  void initState() {
    super.initState();

    _stopWatchTimer = StopWatchTimer();
    _startTime();

  }

  void _startTime() {
    max = widget.sensor.max!;
     state = widget.sensor.state!;
    _initialTime = formatMilliseconds(max);
    _selectedTime = formatMilliseconds(max);
    state = !state;
    if(state){
      _onSelected = true;
      _offSelected = false;
    }else{
      _onSelected = false;
      _offSelected = true;
    }
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Dispositivo'),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children:  [
            Text(
              widget.sensor.name.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10.0,),
            const Divider(height: 5.0,),
            Text(
              widget.sensor.description.toString(),
              style:const TextStyle(
                fontSize: 16.0
              ),
            ),
            const SizedBox(height: 15.0,),
            const Divider(height: 5.0,),
            const Text(
              "Cronograma",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "Intervalo de tiempo",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        _selectTime(),
                        ElevatedButton(
                          onPressed: () {
                            _resetTimer();
                            int millis = convertirTiempoAMilisegundos(
                              _initialTime.hours, _initialTime.minutes, _initialTime.seconds
                            );
                            controller.setValueEngine("max", millis);
                          }, 
                          child: const Text(
                            "Guardar intervalo",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox( height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snapshot) {
                            final value = snapshot.data!;
                            var remainingTimeInSeconds = _calculateTotalSeconds() - (value ~/ 1000);
                            final displayTime = _getDisplayTime(remainingTimeInSeconds);

                            if (remainingTimeInSeconds <= 0) {
                              _resetTimer();
                              if(_onSelected) { 
                                print("true");
                                //controller.setValueEngine("state", true);
                              } else {
                                print("false");
                                //controller.setValueEngine("state", false);
                              }
                            }
                        
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _timeCard(
                                        "Encendido",
                                        background: _onSelected ? Colors.green: Colors.white,
                                        colorLabel: _onSelected ? Colors.white: Colors.black
                                      ),

                                      _timeCard(
                                        "Apagado",
                                        background: _offSelected ? Colors.green: Colors.white,
                                        colorLabel: _offSelected ? Colors.white: Colors.black
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    displayTime,
                                    style: const TextStyle(fontSize: 48),
                                  )
                                ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _resetTimer() {
    _initialTime.hours = _selectedTime.hours;
    _initialTime.minutes = _selectedTime.minutes;
    _initialTime.seconds = _selectedTime.seconds;

    _stopWatchTimer.onStopTimer();
    _stopWatchTimer.onResetTimer();
    _stopWatchTimer.setPresetTime(mSec: _calculateTotalSeconds());
    _stopWatchTimer.onStartTimer();

    _onSelected = !_onSelected;
    _offSelected = !_offSelected;
    print("Reset!!!");
  }

  _timeCard(String title, { Color background = Colors.white, Color colorLabel = Colors.black }) {
    return Card(
      elevation: 10.0,
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorLabel
              )
            ),
          ],
        ),
      ),
    );
  }

  _selectTime() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10.0,),
          GestureDetector(
            onTap: () async {
              Future<TimeOfDay?> pickedTime = showTimePicker(
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                initialEntryMode: TimePickerEntryMode.input,
                context: context,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              pickedTime.then((value) => {
                if(value != null){
                  setState(() {
                    _selectedTime.hours = value.hour;
                    _selectedTime.minutes = value.minute;
                    _selectedTime.seconds = 0;
                  })
                }
              });
            },
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "${_selectedTime.hours}H: ${_selectedTime.minutes}M: ${_selectedTime.seconds}S",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SelectedTime formatMilliseconds(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();

    int remainingSeconds = seconds % 60;
    int remainingMinutes = minutes % 60;
    SelectedTime selectedTime = SelectedTime(
                                    hours: hours,
                                    minutes: remainingMinutes,
                                    seconds: remainingSeconds
                                );
    return selectedTime;
  }

  int convertirTiempoAMilisegundos(int horas, int minutos, int segundos) {
    int milisegundosEnHora = 3600000;
    int milisegundosEnMinuto = 60000;
    int milisegundosEnSegundo = 1000;

    int totalMilisegundos =
        horas * milisegundosEnHora + minutos * milisegundosEnMinuto + segundos * milisegundosEnSegundo;

    return totalMilisegundos;
  }


  int _calculateTotalSeconds() {
    return (_initialTime.hours * 3600) + (_initialTime.minutes * 60) + _initialTime.seconds;
  }

  String _getDisplayTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


}

class SelectedTime{
  int hours;
  int minutes;
  int seconds;

  SelectedTime({ required this.hours, required this.minutes, required this.seconds });
}