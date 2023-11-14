
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ShowDeviceDriverScreen extends StatefulWidget{
  const ShowDeviceDriverScreen({super.key});

  @override
  State<ShowDeviceDriverScreen> createState() => _ShowDeviceDriverScreenState();
}

class _ShowDeviceDriverScreenState extends State<ShowDeviceDriverScreen> {

  late StopWatchTimer _stopWatchTimer;

  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;
  bool isTimeUp = false;

  DateTime _selectedTime = DateTime.now();

  int max = 10000;
  bool state = true;
  bool low = false;
  late Map<String, int> mapTime;

  late bool _onSelected;
  late bool _offSelected;
  int valueTimer = 0;

  @override
  void initState() {
    super.initState();
    //_stopWatchTimer.setPresetTime(mSec: initialTimeInSeconds);
    //_onSelected = SelectedTime(hour: 0, minute: 0, isSelected: true);
    //_offSelected = SelectedTime(hour: 0, minute: 0, isSelected: false);
    _stopWatchTimer = StopWatchTimer();

    mapTime = formatMilliseconds(max);
    _selectedHours = mapTime["hours"]!;
    _selectedMinutes = mapTime["minutes"]!;
    _selectedSeconds = mapTime["seconds"]!;

    if(!state){
      _offSelected = true;
      _onSelected = false;
    }else{
      _onSelected = true;
      _offSelected = false;
    }
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
            const Text(
              "Motor de riego",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10.0,),
            const Divider(height: 5.0,),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque a sapien metus. Nam maximus sem ex, non fringilla diam luctus nec. Integer libero lorem",
              style: TextStyle(
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
                        _selectTime(
                          setState,
                          SelectedTime(hour: 0, minute: 0)
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _stopWatchTimer.setPresetTime(mSec: _calculateTotalSeconds());
                            _stopWatchTimer.onStartTimer();

                            //Conversión y guardar
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

                            if (remainingTimeInSeconds <= 0 && !low) {
                              _stopWatchTimer.onStopTimer();
                              low = true;
                              // _onSelected = !_onSelected;
                              // _offSelected = !_offSelected;
                              print("onselected conclu");
                            }

                            if(low){
                              _selectedHours = mapTime["hours"]!;
                              _selectedMinutes = mapTime["minutes"]!;
                              _selectedSeconds = mapTime["seconds"]!;
                              _stopWatchTimer.setPresetTime(mSec: _calculateTotalSeconds());
                              _stopWatchTimer.onStartTimer();
                              _stopWatchTimer.rawTime;
                            }

                            // if(remainingTimeInSeconds <= 0 && _offSelected){

                            // }

                            // if (remainingTimeInSeconds <=snapshot 0 && _offSelected) {
                            //   _stopWatchTimer.onStopTimer();
                            //   _onSelected = false;
                            //   print("Concluido");
                            // }
                        
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

  _selectTime(StateSetter setState, SelectedTime selectedTime) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10.0,),
          GestureDetector(
            onTap: () async {
              Future<TimeOfDay?> pickedTime = showTimePicker(
                initialTime: TimeOfDay.fromDateTime(_selectedTime),
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
                    _selectedHours = value.hour;
                    _selectedMinutes = value.minute;
                    _selectedSeconds = 0;
                    selectedTime.hour = value.hour;
                    selectedTime.minute = value.minute;
                  })
                }
              });
            },
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "${selectedTime.hour}H: ${selectedTime.minute}M",
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

    Map<String, int> formatMilliseconds(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();

    int remainingSeconds = seconds % 60;
    int remainingMinutes = minutes % 60;

    return {
      "hours": hours,
      "minutes": remainingMinutes,
      "seconds": remainingSeconds
    };
  }


  int _calculateTotalSeconds() {
    return (_selectedHours * 3600) + (_selectedMinutes * 60) + _selectedSeconds;
  }

  String _getDisplayTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


}

class SelectedTime{
  int hour;
  int minute;
  bool isSelected;

  SelectedTime({ required this.hour, required this.minute, this.isSelected = false });
}