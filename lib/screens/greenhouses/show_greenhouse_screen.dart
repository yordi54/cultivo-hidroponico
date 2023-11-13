

import 'package:cultivo_hidroponico/screens/greenhouses/devices_screen.dart';
import 'package:cultivo_hidroponico/widgets/ritch_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowGreenHouseScreen extends StatefulWidget{
  const ShowGreenHouseScreen({super.key});

  @override
  State<ShowGreenHouseScreen> createState() => _ShowGreenHouseScreenState();
}

class _ShowGreenHouseScreenState extends State<ShowGreenHouseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Invernadero 1'),
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
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/icons8-invernadero-48.png'), // Agrega la ruta de tu foto de perfil
              ),
            ),
            const SizedBox(height: 20),          
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles: ',
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold
                  )
                ),
                Card(
                  elevation: 5.0,
                  color: Color.fromRGBO(105, 240, 174, 1),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        RichTextItem(
                          icons: Icons.insert_drive_file_outlined,
                          label: "Capacidad",
                          value: "200"
                        ),
                        Divider( height: 5.0,),
                        RichTextItem(
                          icons: Icons.insert_drive_file_outlined,
                          label: "Área",
                          value: "15"
                        ),
                        Divider( height: 5.0,),
                        RichTextItem(
                          icons: Icons.insert_drive_file_outlined,
                          label: "Estado",
                          value: "Activo"
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cultivos',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 5.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      NavigationChip(
                        label: 'Chip1',
                        onTap: () {
                          print("chip 1");
                        }
                      ),
                      NavigationChip(
                        label: 'Chip1',
                        onTap: () {
                          print("chip 2");
                        }
                      ),
                      // Agrega más chips según sea necesario
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dispositivos',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 5.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      NavigationChip(
                        label: 'Dispositivos',
                        onTap: () {
                          Get.to(() => const DevicesScreen());
                        },
                      ),
                      NavigationChip(
                        label: 'Reportes',
                        onTap: () {
                          print("Ir a reportes");
                        },
                      ),
                      NavigationChip(
                        label: 'Eventos',
                        onTap: () {
                          print("Ir a eventos");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}

class NavigationChip extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const NavigationChip({Key? key, required this.label, this.onTap}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white
          )
        ),
      ),
    );
  }
}