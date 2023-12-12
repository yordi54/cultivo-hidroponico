import 'package:cultivo_hidroponico/screens/privacy_terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('About'),
        ),
        backgroundColor: Colors.green,
        elevation: 10,
      ),
      body: Container(
        padding: const EdgeInsetsDirectional.all(5),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => const PrivacyTermsScreen());
              },
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: const Size(2000, 50),
              ),
              child: const Text(
                'Términos y condiciones',
                style: TextStyle(fontSize: 20 ,color: Colors.white)
              )
            )
          ],
        ),
      ),
    );
  }
}
