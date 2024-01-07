import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:e_mushaf/app/modules/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/providers/api.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(
        HomeRepository(
          Get.find<Api>(),
        ),
      ),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('E-Mushaf'),
            centerTitle: true,
            leading: const SizedBox.shrink(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => controller.changeTheme(),
            child: FaIcon(
              Get.isDarkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
            ),
          ),
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: const Text(
                "Tap sekali lagi untuk keluar",
              ),
              backgroundColor: Get.isDarkMode ? lightPrimary : darkPrimary,
            ),
            child: DefaultTabController(
              length: 3,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150.h,
                      width: Get.width.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          colors: [
                            Get.isDarkMode ? lightSecondary : darkSecondary,
                            Get.isDarkMode ? lightPrimary : darkPrimary,
                          ],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.r),
                          onTap: () {
                            controller.lastReadData.isEmpty
                                ? Get.snackbar(
                                    "Notifikasi",
                                    "Kamu belum memiliki data terakhir dibaca",
                                    backgroundColor: errorColor,
                                    colorText: lightColor,
                                  )
                                : Get.toNamed(
                                    controller.lastReadData[0].via == "Juz"
                                        ? Routes.DETAIL_JUZ
                                        : Routes.DETAIL_SURAH,
                                    arguments: controller.lastReadData[0].via ==
                                            "Juz"
                                        ? {
                                            'juz':
                                                controller.lastReadData[0].juz,
                                            'scrollTo': controller
                                                .lastReadData[0].indexAyat,
                                          }
                                        : {
                                            'surah': controller.listOfSurahName
                                                    .indexOf(controller
                                                        .lastReadData[0]
                                                        .surah!) +
                                                1,
                                            'scrollTo': controller
                                                .lastReadData[0].indexAyat,
                                          },
                                  );
                          },
                          onLongPress: () {
                            controller.lastReadData.isNotEmpty
                                ? Get.defaultDialog(
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
                                            "Yakin ingin menghapus penanda?",
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
                                                    Get.back();
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
                                                    "Tidak",
                                                    style: TextStyle(
                                                      color: Get.isDarkMode
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
                                                    controller.deleteLastRead(
                                                      controller
                                                          .lastReadData[0].id!,
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
                                                    "Ya",
                                                    style: TextStyle(
                                                      color: Get.isDarkMode
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
                                  )
                                : Get.snackbar(
                                    "Notifikasi",
                                    "Kamu belum memiliki data terakhir dibaca",
                                    backgroundColor: errorColor,
                                    colorText: lightColor,
                                  );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: -10,
                                  right: 0,
                                  child: Opacity(
                                    opacity: Get.isDarkMode ? 0.5 : 1,
                                    child: SizedBox(
                                      height: 120.h,
                                      width: 120.w,
                                      child: Image.asset(
                                          "assets/images/mushaf-icon.png"),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          size: 28.sp,
                                          color: Get.isDarkMode
                                              ? darkPrimary
                                              : lightPrimary,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.h),
                                          child: Text(
                                            "Terakhir dibaca",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Get.isDarkMode
                                                  ? darkPrimary
                                                  : lightPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    Text(
                                      controller.lastReadData.isNotEmpty
                                          ? controller.lastReadData[0].surah!
                                          : "",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Get.isDarkMode
                                            ? darkPrimary
                                            : lightPrimary,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      controller.lastReadData.isNotEmpty
                                          ? "Juz ${controller.lastReadData[0].juz ?? ""} | Ayat ${controller.lastReadData[0].ayat ?? ""}"
                                          : "",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Get.isDarkMode
                                            ? darkPrimary
                                            : lightPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TabBar(
                      indicatorColor:
                          Get.isDarkMode ? lightPrimary : darkPrimary,
                      tabs: const [
                        Tab(text: "Surah"),
                        Tab(text: "Juz"),
                        Tab(text: "Penanda"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          controller.isLoading
                              ? const SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.listSurah.data?.length ?? 0,
                                  controller: ScrollController(),
                                  itemBuilder: (context, index) => ListTile(
                                    onTap: () => Get.toNamed(
                                        Routes.DETAIL_SURAH,
                                        arguments: {
                                          'surah': controller
                                              .listSurah.data?[index].number,
                                          'scrollTo': null,
                                        }),
                                    leading: Container(
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
                                          controller
                                                  .listSurah.data?[index].number
                                                  .toString() ??
                                              "",
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      controller.listSurah.data![index].name!
                                          .transliteration!.id!
                                          .replaceAll("'", ""),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                        '${controller.listSurah.data?[index].numberOfVerses.toString() ?? ''} Ayat | ${controller.listSurah.data?[index].revelation?.id ?? ''}'),
                                    trailing: Text(
                                      controller.listSurah.data?[index].name
                                              ?.short ??
                                          "",
                                    ),
                                  ),
                                ),
                          controller.isLoading
                              ? const SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 30,
                                  controller: ScrollController(),
                                  itemBuilder: (context, index) => ListTile(
                                    onTap: () => Get.toNamed(
                                      Routes.DETAIL_JUZ,
                                      arguments: {
                                        'juz': index + 1,
                                        'scrollTo': null,
                                      },
                                    ),
                                    leading: Container(
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
                                          controller
                                                  .listSurah.data?[index].number
                                                  .toString() ??
                                              "",
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "Juz ${index + 1}",
                                    ),
                                  ),
                                ),
                          controller.isLoading
                              ? const SizedBox()
                              : controller.bookmarkData.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "Belum ada penanda yang terdaftar",
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.bookmarkData.length,
                                      controller: ScrollController(),
                                      itemBuilder: (context, index) => ListTile(
                                        contentPadding: EdgeInsets.all(8.sp),
                                        onTap: () {
                                          Get.toNamed(
                                            controller.bookmarkData[index]
                                                        .via ==
                                                    "Juz"
                                                ? Routes.DETAIL_JUZ
                                                : Routes.DETAIL_SURAH,
                                            arguments: controller
                                                        .bookmarkData[index]
                                                        .via ==
                                                    "Juz"
                                                ? {
                                                    'juz': controller
                                                        .bookmarkData[index]
                                                        .juz,
                                                    'scrollTo': controller
                                                        .bookmarkData[index]
                                                        .indexAyat,
                                                  }
                                                : {
                                                    'surah': controller
                                                        .bookmarkData[index]
                                                        .surah_number,
                                                    'scrollTo': controller
                                                        .bookmarkData[index]
                                                        .indexAyat,
                                                  },
                                          );
                                        },
                                        onLongPress: () {
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
                                                    "Yakin ingin menghapus penanda?",
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
                                                            Get.back();
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<
                                                                        Color?>(
                                                              Get.isDarkMode
                                                                  ? darkPrimary
                                                                  : lightPrimary,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Tidak",
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
                                                                .deleteBookmark(
                                                              controller
                                                                  .bookmarkData[
                                                                      index]
                                                                  .id!,
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<
                                                                        Color?>(
                                                              Get.isDarkMode
                                                                  ? darkPrimary
                                                                  : lightPrimary,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Ya",
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
                                        leading: Container(
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
                                              "${index + 1}",
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          "${controller.bookmarkData[index].surah}",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Juz: ${controller.bookmarkData[index].juz}",
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                            Text(
                                              "Ayat: ${controller.bookmarkData[index].ayat}",
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4.sp),
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                color: Get.isDarkMode
                                                    ? lightPrimary
                                                    : darkPrimary,
                                              ),
                                              child: Text(
                                                "${controller.bookmarkData[index].via}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Get.isDarkMode
                                                      ? darkPrimary
                                                      : lightPrimary,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              "${controller.bookmarkData[index].short}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
