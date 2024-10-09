// ignore_for_file: file_names, missing_required_param

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';

class Themes {
  static final colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color(0xFF0C89DA),
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 77, 181, 160),
    background: const Color.fromARGB(255, 52, 52, 52),
  );

  static ThemeData lightTheme = ThemeData().copyWith(
    colorScheme: colorScheme,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueGrey.withOpacity(.4),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    ),
    textTheme: const TextTheme().copyWith(
      titleLarge: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.black87,
      ),
      titleSmall: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.black54,
      ),
      bodySmall: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      bodyMedium: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      labelSmall: const TextStyle(
        fontWeight: FontWeight.w200,
        color: Colors.black54,
      ),
      labelMedium: const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.black87,
      ),
      labelLarge: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData().copyWith(
    colorScheme: darkColorScheme,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueGrey.withOpacity(.4),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    ),
    textTheme: const TextTheme().copyWith(
      titleLarge: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.white70,
      ),
      titleSmall: const TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.white54,
      ),
      bodySmall: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.white54,
      ),
      bodyMedium: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
      bodyLarge: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      labelSmall: const TextStyle(
        fontWeight: FontWeight.w200,
        color: Colors.white54,
      ),
      labelMedium: const TextStyle(
        fontWeight: FontWeight.w300,
        color: Colors.white70,
      ),
      labelLarge: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),
  );

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Color getColor(Color dark, Color light) {
    return is_Dark!.getString('is_dark') == 'true' ? dark : light;
  }

  static bool isDarkMode() {
    return is_Dark!.getString('is_dark') == 'true' ? true : false;
  }

  static get_notification_info(String Image, String title, String message) {
    snackBar sb = snackBar(
      path: 'assets/images/$Image.png',
      BorderColor: Image == "check" ? Colors.greenAccent : Colors.redAccent,
      message: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: Get.mediaQuery.size.width / 25,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: Get.mediaQuery.size.width / 25,
          ),
        ),
      ),
    );
    sb.snackbar();
  }

  static no_internet_connection() {
    snackBar sb = snackBar(
      BorderColor: Colors.red,
      title: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          "No Internet",
          style: Get.theme.textTheme.titleMedium,
        ),
      ),
      message: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Text(
          "Connection !",
          style: Get.theme.textTheme.titleMedium,
        ),
      ),
    );
    sb.snackbar();
  }

  static String? getUserToken() {
    return Auth!.getString("token")!;
  }
}
