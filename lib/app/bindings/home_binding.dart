import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/log_tab_controller.dart';
import '../controllers/main_tab_controller.dart';
import '../services/storage_service.dart';
import '../services/progress_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(StorageService(), permanent: true);
    Get.put(ProgressService(), permanent: true);

    // Controllers
    Get.put(HomeController(), permanent: true);
    Get.put(MainTabController(), permanent: true);
    Get.put(LogTabController(), permanent: true);
  }
}
