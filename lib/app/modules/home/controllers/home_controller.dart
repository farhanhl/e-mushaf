import 'package:e_mushaf/app/data/models/bookmark_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/database/bookmark_database.dart';
import '../../../data/models/list_surah_model.dart';
import '../../../widgets/error_handler_widget.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  ListSurah listSurah = ListSurah();
  bool isLoading = false;
  HomeRepository repository;
  HomeController(this.repository);
  DatabaseManager database = DatabaseManager.instance;
  List<BookMark> lastReadData = [];
  List<BookMark> bookmarkData = [];
  List<String> listOfSurahName = [];

  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  Future<void> getData() async {
    try {
      isLoading = true;
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      listSurah = await repository.getListSurah();
      for (int i = 0; i < listSurah.data!.length; i++) {
        listOfSurahName.add(
          listSurah.data![i].name!.transliteration!.id!.replaceAll("'", ""),
        );
      }
      await getLastReadData();
      await getBookmarkData();
      EasyLoading.dismiss();
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      EasyLoading.dismiss();
      ErrorHandlerWidget.errorDialog(
        onPressedButton: () {
          Get.back();
          getData();
        },
      );
    }
  }

  void changeTheme() {
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (Get.isDarkMode) {
        box.write("isDarkMode", true);
      } else {
        box.remove("isDarkMode");
      }
      update();
    });
  }

  Future<void> getLastReadData() async {
    Database db = await database.db;
    List rawLastReadData = [];
    rawLastReadData = await db.query("bookmark", where: "last_read = 1");
    lastReadData =
        rawLastReadData.map((json) => BookMark.fromJson(json)).toList();
    update();
  }

  Future<void> getBookmarkData() async {
    Database db = await database.db;
    List rawLastReadData = [];
    rawLastReadData = await db.query("bookmark", where: "last_read = 0");
    bookmarkData =
        rawLastReadData.map((json) => BookMark.fromJson(json)).toList();
    update();
  }

  void deleteBookmark(int index) async {
    Database db = await database.db;
    EasyLoading.show(
      status: 'Loading...',
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
    await db.delete("bookmark", where: "id = $index");
    await getBookmarkData();
    Get.back();
    EasyLoading.dismiss();
  }

  void deleteLastRead(int index) async {
    Database db = await database.db;
    EasyLoading.show(
      status: 'Loading...',
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
    await db.delete("bookmark", where: "id = $index");
    await getLastReadData();
    Get.back();
    EasyLoading.dismiss();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
