import 'package:e_mushaf/app/modules/home/repository/home_repository.dart';
import 'package:get/get.dart';

import '../../../core/providers/api.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        HomeRepository(
          Get.find<Api>(),
        ),
      ),
    );
  }
}
