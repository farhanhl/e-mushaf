import 'package:e_mushaf/app/data/models/detail_juz_model.dart';
import 'package:e_mushaf/app/modules/detail_juz/repository/detail_juz_repository.dart';
import 'package:e_mushaf/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/database/bookmark_database.dart';
import '../../../data/models/list_surah_model.dart';
import '../../../data/models/surah_model.dart';
import '../../../utils/audio_status.dart';
import '../../../utils/metode_simpan.dart';
import '../../../widgets/error_handler_widget.dart';

class DetailJuzController extends GetxController {
  DatabaseManager database = DatabaseManager.instance;
  final arguments = Get.arguments;
  AutoScrollController scrollC = AutoScrollController();
  final homeC = Get.find<HomeController>();
  DetailJuzRepository repository;
  DetailJuzController(this.repository);
  DetailJuz detailJuz = DetailJuz();
  List<Surah> listOfSurahNames = [];
  List checkData = [];
  bool isExecuted = true;
  bool isLoading = false;
  int indexOfSurahName = 0;
  final player = AudioPlayer();
  AudioStatus audioStatus = AudioStatus.stopped;
  int? lastPlayedAudioIndex;

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
      detailJuz = await repository.getDetailJuz(arguments['juz']);
      setSurahName();
      getDetailSurahName();
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

  void setSurahName() async {
    String start =
        detailJuz.data?.juzStartInfo?.split(" - ").first.replaceAll("'", "") ??
            "";
    String end =
        detailJuz.data?.juzEndInfo?.split(" - ").first.replaceAll("'", "") ??
            "";

    bool isContinue = false;

    for (ListSurahData item in homeC.listSurah.data!) {
      if (item.name?.transliteration?.id?.replaceAll("'", "") == start) {
        isContinue = true;
        listOfSurahNames.add(
          Surah(
            arab: item.name?.short ?? "",
            latin: item.name?.transliteration?.id?.replaceAll("'", "") ?? "",
          ),
        );
      } else if (item.name?.transliteration?.id?.replaceAll("'", "") == end) {
        listOfSurahNames.add(
          Surah(
            arab: item.name?.short ?? "",
            latin: item.name?.transliteration?.id?.replaceAll("'", "") ?? "",
          ),
        );
        break;
      } else if (isContinue) {
        listOfSurahNames.add(
          Surah(
            arab: item.name?.short ?? "",
            latin: item.name?.transliteration?.id?.replaceAll("'", "") ?? "",
          ),
        );
      }
    }
  }

  void getDetailSurahName() async {
    for (Verses item in detailJuz.data!.verses!) {
      if (isExecuted) {
        if (item.number?.inSurah == 1) {
          if (isExecuted) {
            isExecuted = false;
            item.surahNameLatin = listOfSurahNames[indexOfSurahName].latin;
            item.surahNameArab = listOfSurahNames[indexOfSurahName].arab;
          } else {
            item.surahNameLatin = listOfSurahNames[indexOfSurahName].latin;
            item.surahNameArab = listOfSurahNames[indexOfSurahName].arab;
          }
        } else {
          item.surahNameLatin = listOfSurahNames[indexOfSurahName].latin;
          item.surahNameArab = listOfSurahNames[indexOfSurahName].arab;
        }
      } else {
        if (item.number?.inSurah == 1) {
          isExecuted = false;
          indexOfSurahName++;
          item.surahNameLatin = listOfSurahNames[indexOfSurahName].latin;
          item.surahNameArab = listOfSurahNames[indexOfSurahName].arab;
        } else {
          item.surahNameLatin = listOfSurahNames[indexOfSurahName].latin;
          item.surahNameArab = listOfSurahNames[indexOfSurahName].arab;
        }
      }
    }
  }

  void addBookMark(MetodeSimpan metode, DetailJuzData juz, int index) async {
    Database db = await database.db;
    EasyLoading.show(
      status: 'Loading...',
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
    int surahNumber = homeC.listOfSurahName
            .indexOf(juz.verses![index].surahNameLatin!.replaceAll("'", "")) +
        1;

    try {
      if (metode == MetodeSimpan.terakhirDibaca) {
        await db.delete("bookmark", where: "last_read = 1");
      } else {
        checkData = await db.query(
          "bookmark",
          where:
              "surah = '${juz.verses![index].surahNameLatin!.replaceAll("'", "")}' and surah_number = $surahNumber and ayat = ${juz.verses![index].number!.inSurah} and juz = ${juz.verses![index].meta!.juz} and via = 'Juz' and short = '${juz.verses![index].surahNameArab}' and index_ayat = $index and last_read = 0",
        );
      }
      if (checkData.isEmpty || metode == MetodeSimpan.terakhirDibaca) {
        db.insert(
          "bookmark",
          {
            "surah": juz.verses![index].surahNameLatin!.replaceAll("'", ""),
            "surah_number": surahNumber,
            "ayat": juz.verses![index].number!.inSurah,
            "juz": juz.verses![index].meta!.juz,
            "via": "Juz",
            "short": juz.verses![index].surahNameArab,
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

  void playAudio(String? url, int index) async {
    if (lastPlayedAudioIndex == null) {
      lastPlayedAudioIndex = index;
    } else if (lastPlayedAudioIndex != index) {
      detailJuz.data?.verses?[lastPlayedAudioIndex!].audioStatus =
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
        detailJuz.data?.verses?[index].audioStatus = AudioStatus.playing;
        update();
        EasyLoading.dismiss();
        await player.play();
        detailJuz.data?.verses?[index].audioStatus = AudioStatus.stopped;
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
    if (detailJuz.data?.verses?[index].audioStatus == AudioStatus.playing) {
      try {
        await player.pause();
        detailJuz.data?.verses?[index].audioStatus = AudioStatus.paused;
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
    if (detailJuz.data?.verses?[index].audioStatus == AudioStatus.paused) {
      try {
        detailJuz.data?.verses?[index].audioStatus = AudioStatus.playing;
        update();
        await player.play();
        detailJuz.data?.verses?[index].audioStatus = AudioStatus.stopped;
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
      detailJuz.data?.verses?[index].audioStatus = AudioStatus.stopped;
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
