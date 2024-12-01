import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/tabs/main_tab.dart';
import '../views/tabs/log_tab.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              MainTabView(),
              LogTabView(),
            ],
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '메인',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: '기록',
            ),
          ],
        ),
      ),
    );
  }
}
