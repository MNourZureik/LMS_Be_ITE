// ignore_for_file: non_constant_identifier_names , file_names, unused_local_variable, missing_required_param

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';
import 'package:public_testing_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/api.dart';

class RegisterPassController extends GetxController {
  final Form_Key = GlobalKey<FormState>();
  Widget? circle;

  //Controllers :
  final user_name = TextEditingController();
  final pass_word = TextEditingController();
  final confirm_pass_word = TextEditingController();
  bool isSecurePassword = true;
  bool isSecurePasswordConfirm = true;

  void set_user_password(String user_type, String user_url) async {
    try {
      final data = {
        "password": pass_word.text,
        "confirm_password": confirm_pass_word.text,
      };

      final decodedResposne = await Api.post_request_with_token(user_url, data);
      // successfull go to homePageDoctor :
      if (decodedResposne["status"] == 200) {
        Auth!.setString('login', '200');
        if (Auth!.getString('user') == 'non_active_$user_type') {
          Auth!.setString('user', 'active_$user_type');
        }
        Get.offAllNamed('StudentHomePageScreen');
      }
      // wrong confirm pass :
      else if (decodedResposne["status"] == 401) {
        Themes.get_notification_info(
            "cross", "Error!", "Confirm password and password isn`t the same.");
        circle = null;
        update(["CIRPass"]);
      }
      // some thing went wrong :
      else {
        Themes.get_notification_info(
            "cross", "Error!", "Something Went Wrong.");
        circle = null;
        update(["CIRPass"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void onSave() async {
    if (Form_Key.currentState!.validate()) {
      Form_Key.currentState!.save();
      // activate the circle indecater :
      circle = const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      );
      update(["CIRPass"]);
      // set username and password in cache :
      Auth!.setString('user_name', user_name.text);
      // set password doctor :
      if (Auth!.getString('user') == 'non_active_doctor') {
        set_user_password('doctor', 'set-password-doctor');
      }
      // set password student :
      else if (Auth!.getString('user') == 'non_active_student') {
        set_user_password('student', 'set-password-student');
      }
      // set password teacher :
      else if (Auth!.getString('user') == 'non_active_teacher') {
        set_user_password('teacher', 'set-password-teacher');
      }
    } else {
      return;
    }
  }

  Widget togglePassWord() {
    return IconButton(
      onPressed: () {
        isSecurePassword = !isSecurePassword;
        update();
      },
      icon: isSecurePassword
          ? Image(
              image: const AssetImage('assets/images/eye.png'),
              width: 28,
              height: 28,
              color: Themes.getColor(
                Themes.darkColorScheme.primary,
                Themes.colorScheme.primary,
              ),
            )
          : Image(
              image: const AssetImage('assets/images/show.png'),
              width: 28,
              height: 28,
              color: Themes.getColor(
                Themes.darkColorScheme.primary,
                Themes.colorScheme.primary,
              ),
            ),
    );
  }

  Widget toggleConfirmPassWord() {
    return IconButton(
      onPressed: () {
        isSecurePasswordConfirm = !isSecurePasswordConfirm;
        update();
      },
      icon: isSecurePasswordConfirm
          ? Image(
              image: const AssetImage('assets/images/eye.png'),
              width: 28,
              height: 28,
              color: Themes.getColor(
                Themes.darkColorScheme.primary,
                Themes.colorScheme.primary,
              ),
            )
          : Image(
              image: const AssetImage('assets/images/show.png'),
              width: 28,
              height: 28,
              color: Themes.getColor(
                Themes.darkColorScheme.primary,
                Themes.colorScheme.primary,
              ),
            ),
    );
  }

  @override
  void dispose() {
    user_name.dispose();
    pass_word.dispose();
    super.dispose();
  }

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
}
