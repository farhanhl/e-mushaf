import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/providers/api.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "E-Mushaf",
          theme: box.read("isDarkMode") == true ? darkTheme : lightTheme,
          darkTheme: darkTheme,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          builder: EasyLoading.init(),
          initialBinding: BindingsBuilder(
            () async {
              Get.put(
                Api(),
                permanent: true,
              );
            },
          ),
        );
      },
    ),
  );
}
