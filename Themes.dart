// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Themes {
  static final colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color(0xFF0C89DA),
    background: const Color(0xFF1E40AF),
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFFF3F8D1),
    background: const Color(0xFF1F1F1F),
  );

  static ThemeData lightTheme = ThemeData().copyWith(
    //Seed Color
    colorScheme: colorScheme,
    //Text Button
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
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black.withOpacity(.8),
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(.7),
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black.withOpacity(.6),
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(.8),
      ),
      // bodySmall: TextStyle(
      //   fontSize: 15,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.black.withOpacity(.6),
      // ),
      // bodyMedium: TextStyle(
      //   fontSize: 15,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.black.withOpacity(.6),
      // ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(.6),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData().copyWith(
    //Seed Color
    colorScheme: darkColorScheme,
    //Text Button
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
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white.withOpacity(.8),
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(.7),
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(.6),
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(.8),
      ),
      // bodySmall: TextStyle(
      //   fontSize: 15,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.white.withOpacity(.6),
      // ),
      // bodyMedium: TextStyle(
      //   fontSize: 15,
      //   fontWeight: FontWeight.w500,
      //   color: Colors.white.withOpacity(.6),
      // ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(.6),
      ),
    ),
  );
}

