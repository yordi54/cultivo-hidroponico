import 'package:flutter/material.dart';

import '../../models/crop_model.dart';

class ShowCropScreen extends StatelessWidget{
  const ShowCropScreen({super.key, required this.crop});
  final Crop crop;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cultivo ${crop.name}'),
        backgroundColor: Colors.green, // Color de la barra de navegación
      ),
      body: Center(
        child: Card(
          elevation: 4.0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(crop.image.toString()), // Agrega la ruta de tu foto de perfil
                  ),
                ),
                const Text(
                  'Nombre:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green, // Color del texto
                  ),
                ),
                Text(
                  crop.name!,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Descripción:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green, // Color del texto
                  ),
                ),
                Text(
                  crop.description!,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tiempo de Cultivo:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                Text(
                  '${crop.harvestTime!.toString()} días',
                  style: const TextStyle(fontSize: 18),
                ),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}