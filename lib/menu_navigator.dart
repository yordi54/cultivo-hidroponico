import 'package:cultivo_hidroponico/screens/about_screen.dart';
import 'package:cultivo_hidroponico/screens/home_greenhouse_screen.dart';
import 'package:cultivo_hidroponico/screens/privacy_terms_screen.dart';
import 'package:cultivo_hidroponico/screens/queries/plant_health_screen.dart';
import 'package:cultivo_hidroponico/screens/reports/reports_screen.dart';
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
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.chart_square), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Iconsax.document), label: 'Reporte'),
            NavigationDestination(icon: Icon(Iconsax.health), label: 'Mis plantas'),
            NavigationDestination(icon: Icon(Iconsax.information), label: 'About'),
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
    const HomeGreenHouseScreen(),
    const DashboardScreen(),
    const ReportsScreen(),
    const PlantHealthScreen(),
    const AboutScreen()
  ];

}