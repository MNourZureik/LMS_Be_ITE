// ignore_for_file: non_constant_identifier_names, file_names, missing_required_param

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';

import 'package:public_testing_app/src/models/Themes.dart';

class DarkModeController extends GetxController {
  bool is_dark_mode = Themes.isDarkMode();

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Themes.getColor(
          Themes.darkColorScheme.primary,
          Themes.colorScheme.primary,
        ),
        systemNavigationBarColor: Themes.getColor(
          Themes.darkColorScheme.primary,
          Themes.colorScheme.primary,
        ),
      ),
    );
    super.onInit();
  }

  // change to dark mode and visa versa :
  void changeMode(bool dark) {
    if (dark == true) {
      Get.changeThemeMode(ThemeMode.dark);
      is_Dark!.setString('is_dark', 'true');
    } else {
      Get.changeThemeMode(ThemeMode.light);
      is_Dark!.setString('is_dark', 'false');
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Themes.isDarkMode()
            ? Themes.darkColorScheme.primary
            : Themes.colorScheme.primary,
        systemNavigationBarColor: Themes.isDarkMode()
            ? Themes.darkColorScheme.primary
            : Themes.colorScheme.primary,
      ),
    );
    update();
  }
}
