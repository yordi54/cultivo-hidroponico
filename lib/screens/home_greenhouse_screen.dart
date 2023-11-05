import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sensor_screen.dart';
import 'crop_screen.dart';
import 'greenhouse_screen.dart';

class HomeGreenHouseScreen extends StatelessWidget {
  const HomeGreenHouseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBarController());
    return  Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Invernadero'),
        elevation: 3,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.deepOrangeAccent[200],
        //botom tabBar
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          //tamano de la tab
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),       
          controller: controller.tabController,
          tabs: controller.tabs
        ),
        
      ),
      //body tabBar View
      body: TabBarView(
        controller: controller.tabController,
        children: const[
          GreenHouseScreen(),
          SensorScreen(),
          CropScreen(),
        ],
      ),
    );
  }
}

//clase para tabbar con getx
class TabBarController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  //definir los tabs
  final List<Tab> tabs = const[
    Tab(text: 'Invernadero'),
    Tab(text: 'Sensores'),
    Tab(text: 'Cultivo'),
  ];
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}