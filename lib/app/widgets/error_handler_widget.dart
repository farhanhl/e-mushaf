import 'package:e_mushaf/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ErrorHandlerWidget {
  static errorDialog({
    required VoidCallback onPressedButton,
    String title = "Oops..",
    String message = "Something Went Wrong",
    bool isBackButton = false,
    VoidCallback? onPressedBackButton,
  }) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "",
      backgroundColor: Get.isDarkMode ? lightPrimary : darkPrimary,
      content: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Column(
          children: [
            Lottie.asset(
              "assets/lotties/error_animation.json",
              height: 150.h,
              width: 150.w,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              title,
              style: TextStyle(
                color: Get.isDarkMode ? darkPrimary : lightPrimary,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              message,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.isDarkMode ? darkPrimary : lightPrimary,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPressedButton,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color?>(
                        Get.isDarkMode ? darkPrimary : lightPrimary,
                      ),
                    ),
                    child: Text(
                      "Reload",
                      style: TextStyle(
                        color: Get.isDarkMode ? lightPrimary : darkPrimary,
                      ),
                    ),
                  ),
                ),
                isBackButton
                    ? SizedBox(
                        width: 10.w,
                      )
                    : const SizedBox.shrink(),
                isBackButton
                    ? Expanded(
                        child: ElevatedButton(
                          onPressed: onPressedBackButton,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                              Get.isDarkMode ? darkPrimary : lightPrimary,
                            ),
                          ),
                          child: Text(
                            "Back",
                            style: TextStyle(
                              color:
                                  Get.isDarkMode ? lightPrimary : darkPrimary,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
