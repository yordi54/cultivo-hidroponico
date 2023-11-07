import 'package:cultivo_hidroponico/screens/home_greenhouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'screens/dashboard_screen.dart';

class NavigationMenu extends StatelessWidget{
  const NavigationMenu({super.key});
  @override
  Widget build(BuildContext context){
    final controller = Get.put(NavigationController());
    
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: Colors.white,
          indicatorColor: Colors.white.withOpacity(0.1),
          destinations: const[
            NavigationDestination(icon: Icon(Iconsax.chart_square), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Invernadero'),
            NavigationDestination(icon: Icon(Iconsax.calendar_1), label: 'Evento'),
            NavigationDestination(icon: Icon(Iconsax.document), label: 'Reporte'),
          ],
        ),
      ),
      body: Obx( () => controller.screens[controller.selectedIndex.value] ),
    );
  }

}


class NavigationController extends GetxController {
  final Rx<int>  selectedIndex = 0.obs;
  final screens = [
    const DashboardScreen(),
    const HomeGreenHouseScreen(),
    Container( color: Colors.red,),
    Container( color: Colors.yellow,),
  ];

}