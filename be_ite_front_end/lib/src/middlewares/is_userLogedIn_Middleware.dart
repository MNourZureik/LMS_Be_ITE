// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';

class isDoctorMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Auth!.getString('login') == '200') {
      return const RouteSettings(name: 'StudentHomePageScreen');
    }

    return null;
  }
}
