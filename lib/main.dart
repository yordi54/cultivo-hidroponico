//import 'package:cultivo_hidroponico/repositories/report_repository.dart';
//import 'package:cultivo_hidroponico/test/seed_reports.dart';
import 'package:cultivo_hidroponico/db/db_termsacceptence.dart';
import 'package:cultivo_hidroponico/models/termsacceptance_model.dart';
import 'package:cultivo_hidroponico/screens/termsacceptance_screen.dart';
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
  print('onMessage: $token');
  //escuchar mensajes cuando estas en primer plano
  FirebaseMessaging.onMessage.listen((message) {
    print('onMessage: $message');
    // visualizar la notificacion vista
    
  });
  DbTermsAcceptence dbTermsAcceptence = DbTermsAcceptence();
  TermsAcceptance? termsAcceptance = await dbTermsAcceptence.getTermsAcceptance();
  
  runApp(MyApp(termsAcceptance: termsAcceptance,));
}

class MyApp extends StatelessWidget {  
  TermsAcceptance? termsAcceptance;

  MyApp({super.key, this.termsAcceptance});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: 
        termsAcceptance != null && termsAcceptance!.accepted ?
          const NavigationMenu() :
        const TermsAcceptanceScreen()
    );
  }
}


