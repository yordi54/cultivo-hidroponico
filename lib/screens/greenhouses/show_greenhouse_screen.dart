

import 'package:cultivo_hidroponico/controllers/crop_controller.dart';
import 'package:cultivo_hidroponico/models/crop_model.dart';
import 'package:cultivo_hidroponico/screens/crops/show_crop_screen.dart';
import 'package:cultivo_hidroponico/screens/greenhouses/devices_screen.dart';
import 'package:cultivo_hidroponico/widgets/navigation_chip.dart';
import 'package:cultivo_hidroponico/widgets/ritch_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/greenhouse_model.dart';

class ShowGreenHouseScreen extends StatefulWidget{
  const ShowGreenHouseScreen({super.key,required this.greenHouse,});
  final GreenHouse greenHouse;
  @override
  State<ShowGreenHouseScreen> createState() => _ShowGreenHouseScreenState();
}

class _ShowGreenHouseScreenState extends State<ShowGreenHouseScreen> {
  CropController cropController = Get.put(CropController());
  Crop crop = Crop(
    name: '',
    description: '',
    image: '',
    harvestTime: 0,
    id: '',
  ); 
  @override
  void initState() {
    super.initState();
    //final controller = Get.put(TabBar1Controller());
    cropController.getCropById(widget.greenHouse.cropId!).then((value) {
      setState(() {
        crop = value;
      });
    
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text('Invernadero ${widget.greenHouse.name}'),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalles: ',
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold
                  )
                ),
                Card(
                  elevation: 5.0,
                  color: const Color.fromRGBO(105, 240, 174, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        RichTextItem(
                          icons: Icons.insert_drive_file_outlined,
                          label: "Capacidad",
                          value: "${widget.greenHouse.capacity}"
                        ),
                        const Divider( height: 5.0,),
                        RichTextItem(
                          icons: Icons.insert_drive_file_outlined,
                          label: "Área",
                          value: "${widget.greenHouse.area} m2"
                        ),
                        const Divider( height: 5.0,),
                        RichTextItem(
                          icons: Icons.insert_drive_file_outlined,
                          label: "Estado",
                          value: widget.greenHouse.state!
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
                        label: crop.name!,
                        onTap: () {
                          Get.to(ShowCropScreen(crop: crop,));
                        }
                      ),
                      /*NavigationChip(
                        label: 'Chip1',
                        onTap: () {
                          print("chip 2");
                        }
                      ),*/
                      // Agrega más chips según sea necesario
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                          Get.to(() => DevicesScreen(greenHouse: widget.greenHouse,));
                        },
                      ),
                      /*NavigationChip(
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
                      ),*/
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