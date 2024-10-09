// ignore_for_file: non_constant_identifier_names , file_names, unused_local_variable, missing_required_param

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/OtherUsers_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';
import 'package:public_testing_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/api.dart';

class LoginPassController extends GetxController {
  final Form_Key = GlobalKey<FormState>();
  Widget? circle;

  //Controllers :
  final user_name = TextEditingController();
  final pass_word = TextEditingController();
  bool isSecurePassword = true;

  void login_for_user(String user_url, String user_type) async {
    try {
      final data = {
        "email": Auth!.getString('email'),
        "password": pass_word.text,
      };
      final decodedResposne =
          await Api.post_request_without_token(user_url, data);
      // successfull go to homePageDoctor :
      if (decodedResposne["status"] == 200) {
        Auth!.setString('token', "${decodedResposne["data"]["token"]}");
        Auth!.setString('login', '200');
        if (user_url != 'log_in_student_by_password') {
          OtherusersSubjectsController().onInit();
        }

        Get.offAllNamed('StudentHomePageScreen');
        if (user_type == "student") {
          final String? token = await FirebaseMessaging.instance.getToken();
          final data = {
            "fcm_token": token,
          };
          final dec = Api.post_request_with_token("register-fcm-token", data);
        }
      }
      // 201
      else if (decodedResposne["status"] == 201) {
        Themes.get_notification_info("cross", "Error!", "Wrong Password.");

        circle = null;
        update(["CILPass"]);
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
      update(["CILPass"]);

      // set username and password in cache :
      Auth!.setString('user_name', user_name.text);

      // check password doctor :
      if (Auth!.getString('user') == 'active_doctor') {
        login_for_user('log_in_doctor_by_password', "doctor");
      }
      // check password teacher :
      else if (Auth!.getString('user') == 'active_teacher') {
        login_for_user('log_in_teacher_by_password', "teacher");
      }
      // check password student :
      else if (Auth!.getString('user') == 'active_student') {
        login_for_user('log_in_student_by_password', "student");
      }
    } else {
      return;
    }
  }

  void onForgotPassword() async {
    try {
      final data = {
        "email": Auth!.getString('email'),
      };

      final decodedResponse =
          await Api.post_request_without_token("forget-password", data);
    } catch (e) {
      log(e.toString());
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
