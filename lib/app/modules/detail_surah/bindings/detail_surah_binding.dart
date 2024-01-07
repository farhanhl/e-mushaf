import 'package:e_mushaf/app/modules/detail_surah/repository/detail_surah_repository.dart';
import 'package:get/get.dart';
import '../../../core/providers/api.dart';
import '../controllers/detail_surah_controller.dart';

class DetailSurahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSurahController>(
      () => DetailSurahController(
        DetailSurahRepository(
          Get.find<Api>(),
        ),
      ),
    );
  }
}
