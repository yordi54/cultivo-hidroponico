
import 'package:cultivo_hidroponico/screens/greenhouses/device_driver_screen.dart';
import 'package:cultivo_hidroponico/screens/greenhouses/device_monitoring_screen.dart';
import 'package:cultivo_hidroponico/screens/sensors/sensor_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DevicesScreen extends StatelessWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBar1Controller());
    return  Scaffold(
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
        backgroundColor: Colors.greenAccent[200],
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
        children: [
          const DeviceMonitoringScreen(),
          DeviceDriverScreen(),
        ],
      ),
    );
  }
}

//clase para tabbar con getx
class TabBar1Controller extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  //definir los tabs
  final List<Tab> tabs = const[
    Tab(text: 'Monitoreo'),
    Tab(text: 'Controladores'),
  ];
  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}