import 'package:e_mushaf/app/modules/detail_juz/repository/detail_juz_repository.dart';
import 'package:get/get.dart';
import '../../../core/providers/api.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailJuzController>(
      () => DetailJuzController(
        DetailJuzRepository(
          Get.find<Api>(),
        ),
      ),
    );
  }
}
