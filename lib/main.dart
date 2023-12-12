//import 'package:cultivo_hidroponico/repositories/report_repository.dart';
//import 'package:cultivo_hidroponico/test/seed_reports.dart';
import 'dart:async';

import 'package:cultivo_hidroponico/controllers/report_controller.dart';
import 'package:cultivo_hidroponico/helper/local_notification.dart';
import 'package:cultivo_hidroponico/models/greenhouse_model.dart';
import 'package:cultivo_hidroponico/models/greenhouse_report_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'menu_navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('es_ES', null);
  //traer token fcm device
  final token = await FirebaseMessaging.instance.getToken();
  print('Token: $token');
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<RemoteMessage> _subscription;
  ReportController reportRepository = ReportController();
  @override
  void initState() {
    super.initState();
   
    //escuchar mensajes cuando estas en primer plano
    _subscription = FirebaseMessaging.onMessage.listen((message) {
      //print('onMessage: $message');
      //model report
      final  report = {
        'description': message.data['description']!,
        'greenhouse': 'Invernadero 1',
        'date': message.data['date']!,
        'hour': message.data['hour']!,
      };
      //crear reporte 
      LocalNotification().showNotification(
        title: message.notification!.title!,
        body: message.notification!.body!
      );
      reportRepository.create(report).then((value) => {
        Get.snackbar(
          'Reporte',
          'Se ha creado un nuevo reporte',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white,),
        )
      },
      onError: (error) {
        Get.snackbar(
          'Error',
          'No se ha podido crear el reporte',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.error_outline_rounded, color: Colors.white,),
        );
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationMenu(),
    );
  }
}


