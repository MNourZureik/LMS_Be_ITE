// ignore_for_file: file_names, missing_required_param

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/api.dart';
import '../../../main.dart';
import '../../models/SnackBar.dart';

class LogoutController extends GetxController {
  void logout_user_on_authorization(String user_url, String type) async {
    try {
      final decodedResposne = await Api.get_request(user_url);

      // successfull logout :
      if (decodedResposne["status"] == 200) {
        Auth!.setString('user', 'non_active_$type');
        Get.offNamed('EmailPageScreen');
        Auth!.setString('token', 'logged out');
        Auth!.setString('login', '400');
        appData!.setString('user_photo', '');
      } else {
        Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void onLogOut() async {
    if (Auth!.getString('user') == 'active_doctor') {
      logout_user_on_authorization("logout-doctor", "doctor");
    }
    // teacher logout :
    else if (Auth!.getString('user') == 'active_teacher') {
      logout_user_on_authorization("logout-teacher", "teacher");
    }
    // student logout :
    else if (Auth!.getString('user') == 'active_student') {
      logout_user_on_authorization("logout-student", "student");
    }
  }
}
