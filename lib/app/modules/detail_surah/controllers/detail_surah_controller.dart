import 'package:e_mushaf/app/data/database/bookmark_database.dart';
import 'package:e_mushaf/app/modules/detail_surah/repository/detail_surah_repository.dart';
import 'package:e_mushaf/app/utils/audio_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/detail_surah_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/metode_simpan.dart';
import '../../../widgets/error_handler_widget.dart';
import '../../home/controllers/home_controller.dart';

class DetailSurahController extends GetxController {
  DatabaseManager database = DatabaseManager.instance;
  AutoScrollController scrollC = AutoScrollController();
  final homeC = Get.find<HomeController>();
  DetailSurah detailSurah = DetailSurah();
  List checkData = [];
  bool isLoading = false;
  DetailSurahRepository repository;
  DetailSurahController(this.repository);
  final arguments = Get.arguments;
  final player = AudioPlayer();
  AudioStatus audioStatus = AudioStatus.stopped;
  int? lastPlayedAudioIndex;

  @override
  void onInit() async {
    super.onInit();
    await getDetailSurah();
    if (arguments["scrollTo"] != null) {
      scrollToIndex();
    }
  }

  Future<void> getDetailSurah() async {
    try {
      isLoading = true;
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      detailSurah = await repository.getDetailSurah(arguments['surah']);
      EasyLoading.dismiss();
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      EasyLoading.dismiss();
      ErrorHandlerWidget.errorDialog(
        isBackButton: true,
        onPressedButton: () {
          Get.back();
          getDetailSurah();
        },
        onPressedBackButton: () {
          Get.offNamedUntil(
            Routes.HOME,
            (route) => route.isFirst,
          );
        },
      );
    }
  }

  Future scrollToIndex() async {
    await scrollC.scrollToIndex(
      arguments["scrollTo"] + 2,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(seconds: 2),
    );
  }

  void addBookMark(MetodeSimpan metode, SurahData surah, int index) async {
    Database db = await database.db;
    EasyLoading.show(
      status: 'Loading...',
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
    int surahNumber = homeC.listOfSurahName
            .indexOf(surah.name!.transliteration!.id!.replaceAll("'", "")) +
        1;
    print(surahNumber);
    try {
      if (metode == MetodeSimpan.terakhirDibaca) {
        await db.delete("bookmark", where: "last_read = 1");
      } else {
        checkData = await db.query(
          "bookmark",
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "")}' and surah_number = $surahNumber and ayat = ${surah.verses![index].number!.inSurah} and juz = ${surah.verses![index].meta!.juz} and via = 'Surah' and short = '${surah.name!.short}' and index_ayat = $index and last_read = 0",
        );
      }
      if (checkData.isEmpty || metode == MetodeSimpan.terakhirDibaca) {
        db.insert(
          "bookmark",
          {
            "surah": surah.name!.transliteration!.id!.replaceAll("'", ""),
            "surah_number": surahNumber,
            "ayat": surah.verses![index].number!.inSurah,
            "juz": surah.verses![index].meta!.juz,
            "via": "Surah",
            "short": surah.name!.short,
            "index_ayat": index,
            "last_read": metode == MetodeSimpan.terakhirDibaca ? 1 : 0,
          },
        );
        EasyLoading.dismiss();
        Get.back();
        Get.snackbar(
          "Notifikasi",
          metode == MetodeSimpan.terakhirDibaca
              ? "Berhasil mengatur tanda terakhir dibaca"
              : "Berhasil menambahkan penanda",
          backgroundColor: successColor,
          colorText: lightColor,
        );
        metode == MetodeSimpan.terakhirDibaca
            ? homeC.getLastReadData()
            : homeC.getBookmarkData();
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Notifikasi",
          "Penanda sudah terdaftar",
          backgroundColor: errorColor,
          colorText: lightColor,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      Get.snackbar(
        "Notifikasi",
        metode == MetodeSimpan.terakhirDibaca
            ? "Gagal mengatur tanda terakhir dibaca"
            : "Gagal menambahkan penanda",
        backgroundColor: errorColor,
        colorText: lightColor,
      );
    }
  }

  buildTafsirDialog() {
    Get.defaultDialog(
      contentPadding: EdgeInsets.all(16.sp),
      titlePadding: EdgeInsets.all(16.sp),
      backgroundColor: Get.isDarkMode ? darkPrimary : lightPrimary,
      title: "Tafsir Surah ${detailSurah.data?.name?.transliteration?.id}",
      content: Column(
        children: [
          Text(detailSurah.data?.tafsir?.id ?? ""),
          SizedBox(
            height: 10.h,
          ),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                    Get.isDarkMode ? lightPrimary : darkPrimary,
                  ),
                ),
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Get.isDarkMode ? darkPrimary : lightPrimary,
                  ),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }

  void playAudio(String? url, int index) async {
    if (lastPlayedAudioIndex == null) {
      lastPlayedAudioIndex = index;
    } else if (lastPlayedAudioIndex != index) {
      detailSurah.data?.verses?[lastPlayedAudioIndex!].audioStatus =
          AudioStatus.stopped;
      lastPlayedAudioIndex = index;
    }
    if (url != null) {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      try {
        await player.stop();
        await player.setUrl(url);
        detailSurah.data?.verses?[index].audioStatus = AudioStatus.playing;
        update();
        EasyLoading.dismiss();
        await player.play();
        detailSurah.data?.verses?[index].audioStatus = AudioStatus.stopped;
        update();
        await player.stop();
      } on PlayerException catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "${e.message}",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      } on PlayerInterruptedException catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "${e.message}",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      } catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "$e",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      }
    } else {
      ErrorHandlerWidget.errorDialog(
        title: "Terjadi kesalahan",
        message: "Audio tidak tersedia",
        onPressedButton: () => Get.back(),
      );
    }
  }

  void pauseAudio(int index) async {
    if (detailSurah.data?.verses?[index].audioStatus == AudioStatus.playing) {
      try {
        await player.pause();
        detailSurah.data?.verses?[index].audioStatus = AudioStatus.paused;
        update();
      } on PlayerException catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "${e.message}",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      } on PlayerInterruptedException catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "${e.message}",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      } catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "$e",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      }
    } else {
      ErrorHandlerWidget.errorDialog(
        title: "Terjadi kesalahan",
        message: "Gagal saat proses pause audio",
        onPressedButton: () => Get.back(),
      );
    }
  }

  void resumeAudio(int index) async {
    if (detailSurah.data?.verses?[index].audioStatus == AudioStatus.paused) {
      try {
        detailSurah.data?.verses?[index].audioStatus = AudioStatus.playing;
        update();
        await player.play();
        detailSurah.data?.verses?[index].audioStatus = AudioStatus.stopped;
        update();
        await player.stop();
      } on PlayerException catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "${e.message}",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      } on PlayerInterruptedException catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "${e.message}",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      } catch (e) {
        ErrorHandlerWidget.errorDialog(
          title: "Terjadi kesalahan",
          message: "$e",
          onPressedButton: () => Get.back(),
        );
        EasyLoading.dismiss();
      }
    } else {
      ErrorHandlerWidget.errorDialog(
        title: "Terjadi kesalahan",
        message: "Gagal saat proses resume audio",
        onPressedButton: () => Get.back(),
      );
    }
  }

  void stopAudio(index) async {
    try {
      detailSurah.data?.verses?[index].audioStatus = AudioStatus.stopped;
      await player.stop();
      update();
    } catch (e) {
      ErrorHandlerWidget.errorDialog(
        title: "Terjadi kesalahan",
        message: "Ada kesalahan saat memberhentikan audio",
        onPressedButton: () => Get.back(),
      );
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() async {
    super.onClose();
    await player.stop();
    await player.dispose();
    await EasyLoading.dismiss();
  }
}
