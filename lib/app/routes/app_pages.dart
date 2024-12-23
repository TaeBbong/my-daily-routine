import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}

abstract class Routes {
  static const HOME = '/home';
}
