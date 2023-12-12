import 'package:cultivo_hidroponico/db/db_termsacceptence.dart';
import 'package:cultivo_hidroponico/menu_navigator.dart';
import 'package:cultivo_hidroponico/models/termsacceptance_model.dart';
import 'package:cultivo_hidroponico/screens/privacy_terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAcceptanceScreen extends StatefulWidget {
  const TermsAcceptanceScreen({Key? key}) : super(key: key);

  @override
  State<TermsAcceptanceScreen> createState() => _TermsAcceptanceScreenState();
}

class _TermsAcceptanceScreenState extends State<TermsAcceptanceScreen> {
  bool agree = false;


  void _doSomething() async {
    DbTermsAcceptence dbTermsAcceptence = DbTermsAcceptence();
    TermsAcceptance termsAcceptance = TermsAcceptance(id: 1, accepted: true);
    await dbTermsAcceptence.insertTermsAcceptance(termsAcceptance);
    
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('HidroSoft')),
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        elevation: 10,
      ),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Get.to(() => const PrivacyTermsScreen());
          },
          style:ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'Términos y condiciones',
            style: TextStyle(fontSize: 20 ,color: Colors.white)
          )
        ),
        Row(
          children: [
            Material(
              child: Checkbox(
                value: agree,
                onChanged: (value) {
                  setState(() {
                    agree = value ?? false;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            const Text(
              'He leído y acepto términos y condiciones',
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        ElevatedButton(
          onPressed: agree ? _doSomething : null,
          child: const Text(
            'Continuar',
            style: TextStyle(
              color: Colors.green
            ),
          )
        )
      ]),
    );
  }
}