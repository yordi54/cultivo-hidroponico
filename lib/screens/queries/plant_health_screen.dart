import 'dart:convert';
import 'dart:io';

import 'package:cultivo_hidroponico/controllers/plantid_controller.dart';
import 'package:cultivo_hidroponico/models/plantid_analized.dart';
import 'package:cultivo_hidroponico/utils/constants.dart';
import 'package:cultivo_hidroponico/widgets/navigation_chip.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PlantHealthScreen extends StatefulWidget {
  const PlantHealthScreen({super.key});

  @override
  State<PlantHealthScreen> createState() => _PlantHealthScreenState();
}

class _PlantHealthScreenState extends State<PlantHealthScreen> {
  
  PlantIdController plantIdController = PlantIdController();
  final picker = ImagePicker();
  File? fileImage;
  late String _imageBase64;
  bool _isAnalizing = false;
  //PlantIdAnalized? _plantIdAnalized; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Salud de plantas'),
        ),
        backgroundColor: Colors.green,
        elevation: 10,
      ),
      body: Container(
        padding: const EdgeInsetsDirectional.all(20),
        child: ListView(
          children: [
            _headDescription(),
            const Divider(height: 5.0,),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: choiceImage,
                  child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/gallery.png',
                              height: 60,
                              width: 60,
                            ),
                            const Text("Abrir galeria")
                          ],
                        ),
                      )),
                ),
                const Text("Ó", style: TextStyle(fontSize: 16.0),),
                GestureDetector(
                  onTap: choiceImageCamera,
                  child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/camera.png',
                              height: 60,
                              width: 60,
                            ),
                            const Text('Abrir Cámara'),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            _showImage(),
            ElevatedButton(
              onPressed: () async {
                if(fileImage == null){
                  Constants.snackbar(context, "Seleccione una imagen");
                }else{
                  setState(() {
                    _isAnalizing = true;
                  });
                }
                // var plantIdAnalized = await plantIdController.healthAssessment(_imageBase64);
                // print(plantIdAnalized);
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: const Size(2000, 50),
              ),
              child: const Text(
                'Analizar',
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
            ),
            _isAnalizing ?
             _results() :
             const Text("")
          ],
        ),
      ),
    );
  }

  _headDescription() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Descripción:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
            Text(
              'Aquí podrá consultar el estado en el que se encuentra sus plantas.',
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showImage() {
    return SizedBox(
        height: 350.0,
        child: Container(
          height: 350,
          width: 350,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              image: fileImage == null ?
                const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/noimage.jpg")
                ) :
              DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(fileImage!)
              )
            ),
        ));
  }

  _results() {
    return FutureBuilder(
      future: plantIdController.healthAssessment(_imageBase64),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if( snapshot.hasData ){
          PlantIdAnalized plantIdAnalized = snapshot.data;
          return  Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text(
                  "Posibles enfermedades: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
                SizedBox(
                  height: 70.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: plantIdAnalized.result.disease.suggestions.length,
                    itemBuilder: (context, index) {
                      String percentage = (plantIdAnalized.result.disease.suggestions[index].probability * 100).toStringAsFixed(2);
                      return Card(
                        elevation: 5.0,
                        child: NavigationChip(
                          label: "Sugerencia: ${plantIdAnalized.result.disease.suggestions[index].name} |  Probabilidad: $percentage%",
                        )
                      );
                    }
                  )
                )
              ],
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
      }
    );
  }

  Future choiceImage() async {
    try {
      var pickedImage = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedImage == null) return;
        fileImage = File(pickedImage.path);
        List<int> bytes = fileImage!.readAsBytesSync();
        _imageBase64 = base64.encode(bytes);
        _isAnalizing = false;
      });
    } on Exception {
      print("Error");
    }
  }

  Future choiceImageCamera() async {
    try {
      var pickedImage = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        if (pickedImage == null) return;
        fileImage = File(pickedImage.path);
        List<int> bytes = fileImage!.readAsBytesSync();
        _imageBase64 = base64.encode(bytes);
        _isAnalizing = false;
      });
    } on Exception {
      print("Error");
    }
  }
}
