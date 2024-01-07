import 'package:e_mushaf/app/core/theme/app_theme.dart';
import 'package:e_mushaf/app/modules/detail_surah/repository/detail_surah_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../core/providers/api.dart';
import '../../../utils/audio_status.dart';
import '../../../utils/metode_simpan.dart';
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  const DetailSurahView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailSurahController>(
      init: DetailSurahController(
        DetailSurahRepository(
          Get.find<Api>(),
        ),
      ),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'DETAIL SURAH',
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
            builder: (context, snapshot) {
              if (controller.arguments["scrollTo"] != null) {
                controller.scrollC.scrollToIndex(
                  controller.arguments["scrollTo"] + 2,
                  preferPosition: AutoScrollPosition.begin,
                  duration: const Duration(seconds: 3),
                );
              }

              if (!snapshot.hasData) {
                const SizedBox.shrink();
              }

              List<Widget> listOfSurah = List.generate(
                controller.detailSurah.data?.verses?.length ?? 0,
                (index) {
                  return AutoScrollTag(
                    key: ValueKey(index + 2),
                    controller: controller.scrollC,
                    index: index + 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? lightPrimary : darkPrimary,
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      padding: EdgeInsets.all(12.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color:
                                  Get.isDarkMode ? shadowColor : lightPrimary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        Get.isDarkMode
                                            ? "assets/images/list-light.png"
                                            : "assets/images/list-dark.png",
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                        "${controller.detailSurah.data?.verses?[index].number?.inSurah}"
                                        // "${index + 2}",
                                        ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      splashRadius: 10.r,
                                      splashColor: shadowColor,
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "",
                                          backgroundColor: Get.isDarkMode
                                              ? lightPrimary
                                              : darkPrimary,
                                          content: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: Column(
                                              children: [
                                                Lottie.asset(
                                                  "assets/lotties/muslim.json",
                                                  height: 200.h,
                                                  width: 200.w,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(
                                                  "Pilih jenis tipe bookmark",
                                                  style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? darkPrimary
                                                        : lightPrimary,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          controller
                                                              .addBookMark(
                                                            MetodeSimpan
                                                                .terakhirDibaca,
                                                            controller
                                                                .detailSurah
                                                                .data!,
                                                            index,
                                                          );
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color?>(
                                                            Get.isDarkMode
                                                                ? darkPrimary
                                                                : lightPrimary,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Terakhir Dibaca",
                                                          style: TextStyle(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? lightPrimary
                                                                : darkPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          controller
                                                              .addBookMark(
                                                            MetodeSimpan
                                                                .penanda,
                                                            controller
                                                                .detailSurah
                                                                .data!,
                                                            index,
                                                          );
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color?>(
                                                            Get.isDarkMode
                                                                ? darkPrimary
                                                                : lightPrimary,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Penanda",
                                                          style: TextStyle(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? lightPrimary
                                                                : darkPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.bookmark_outline,
                                      ),
                                    ),
                                    controller.detailSurah.data?.verses?[index]
                                                .audioStatus ==
                                            AudioStatus.stopped
                                        ? IconButton(
                                            splashRadius: 10.r,
                                            splashColor: shadowColor,
                                            onPressed: () {
                                              controller.playAudio(
                                                  controller
                                                      .detailSurah
                                                      .data!
                                                      .verses![index]
                                                      .audio!
                                                      .primary!,
                                                  index);
                                            },
                                            icon: const Icon(
                                              Icons.play_arrow,
                                            ),
                                          )
                                        : controller
                                                        .detailSurah
                                                        .data
                                                        ?.verses?[index]
                                                        .audioStatus ==
                                                    AudioStatus.playing ||
                                                controller
                                                        .detailSurah
                                                        .data
                                                        ?.verses?[index]
                                                        .audioStatus ==
                                                    AudioStatus.paused
                                            ? Row(
                                                children: [
                                                  controller
                                                              .detailSurah
                                                              .data
                                                              ?.verses?[index]
                                                              .audioStatus ==
                                                          AudioStatus.playing
                                                      ? IconButton(
                                                          splashRadius: 10.r,
                                                          splashColor:
                                                              shadowColor,
                                                          onPressed: () {
                                                            controller
                                                                .pauseAudio(
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons.pause,
                                                          ),
                                                        )
                                                      : controller
                                                                  .detailSurah
                                                                  .data
                                                                  ?.verses?[
                                                                      index]
                                                                  .audioStatus ==
                                                              AudioStatus.paused
                                                          ? IconButton(
                                                              splashRadius:
                                                                  10.r,
                                                              splashColor:
                                                                  shadowColor,
                                                              onPressed: () {
                                                                controller
                                                                    .resumeAudio(
                                                                        index);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .play_arrow,
                                                              ),
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
                                                  IconButton(
                                                    splashRadius: 10.r,
                                                    splashColor: shadowColor,
                                                    onPressed: () {
                                                      controller
                                                          .stopAudio(index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.stop,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : const SizedBox.shrink()
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text(
                            controller.detailSurah.data?.verses?[index].text
                                    ?.arab ??
                                "",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Get.isDarkMode ? darkColor : lightColor,
                              fontSize: 34.sp,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            controller.detailSurah.data?.verses?[index].text
                                    ?.transliteration?.en ??
                                "",
                            style: TextStyle(
                              color:
                                  Get.isDarkMode ? darkPrimary : lightPrimary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            controller.detailSurah.data?.verses?[index]
                                    .translation?.id ??
                                "",
                            style: TextStyle(
                              color: Get.isDarkMode ? darkColor : lightColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              return ListView(
                controller: controller.scrollC,
                padding: EdgeInsets.all(16.sp),
                children: [
                  AutoScrollTag(
                    key: const ValueKey(0),
                    controller: controller.scrollC,
                    index: 0,
                    child: controller.isLoading == false
                        ? InkWell(
                            // onTap: () => controller.scrollToIndex(),
                            child: Container(
                              height: 120.h,
                              width: Get.width.w,
                              padding: EdgeInsets.all(20.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: LinearGradient(
                                  colors: [
                                    Get.isDarkMode
                                        ? lightSecondary
                                        : darkSecondary,
                                    Get.isDarkMode ? lightPrimary : darkPrimary,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.detailSurah.data?.name
                                            ?.transliteration?.id
                                            ?.toUpperCase()
                                            .replaceAll("'", "") ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Get.isDarkMode
                                          ? darkPrimary
                                          : lightPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    '( ${controller.detailSurah.data?.name?.translation?.id?.toUpperCase() ?? ''} )',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Get.isDarkMode
                                          ? darkPrimary
                                          : lightPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    '${controller.detailSurah.data?.numberOfVerses.toString() ?? ''} Ayat | ${controller.detailSurah.data?.revelation?.id ?? ''}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Get.isDarkMode
                                          ? darkPrimary
                                          : lightPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  AutoScrollTag(
                    key: const ValueKey(1),
                    controller: controller.scrollC,
                    index: 1,
                    child: SizedBox(
                      height: 10.h,
                    ),
                  ),
                  ...listOfSurah,
                ],
              );
            },
          ),
        );
      },
    );
  }
}
