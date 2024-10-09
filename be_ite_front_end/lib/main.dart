// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/Bindings.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/firebase_options.dart';
import 'package:public_testing_app/App_Routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

SharedPreferences? Auth;
SharedPreferences? is_Dark;
SharedPreferences? appData;

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // Ensure that Firebase is initialized)
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  Auth = await SharedPreferences.getInstance();
  is_Dark = await SharedPreferences.getInstance();
  appData = await SharedPreferences.getInstance();

  runApp(
    GetMaterialApp(
      initialBinding: Binding(),
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: Themes.isDarkMode()
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: AppNavigation.getInitRoute,
      getPages: AppNavigation.routes,
    ),
  );
}
