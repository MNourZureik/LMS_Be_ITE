// ignore_for_file: non_constant_identifier_names, missing_required_param

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/api.dart';
import '../../../../main.dart';
import '../../../models/SnackBar.dart';

class ChangePassController extends GetxController {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirm_new_pass_word = TextEditingController();
  bool isSecurePassword = true;
  bool isSecureNewPassword = true;
  bool isSecureConfirmNewPassword = true;

  final formkey = GlobalKey<FormState>();
  bool circle2 = false;

  void change_password_for_user(String user_url) async {
    try {
      // email url :
      final data = {
        'old_password': oldPass.text,
        'new_password': newPass.text,
        "confirm_password": confirm_new_pass_word.text,
      };
      // decoded response :
      final decodedResponse = await Api.post_request_with_token(user_url, data);
      if (decodedResponse["status"] == 200) {
        Get.back();
        Get.back();
        Themes.get_notification_info(
            "check", "Password Changed", "Successfully!");
      }
      // wrong confirm pass :
      else if (decodedResponse["status"] == 401) {
        Themes.get_notification_info("cross", "Error!",
            "Confirm new password and new password isn`t the same.");
      }
      // some thing went wrong :
      else if (decodedResponse["status"] == 400) {
        Themes.get_notification_info("cross", "Error!", "Wrong Password.");
      } else {
        Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
      }
      circle2 = false;
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  void onChangePass() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      circle2 = true;
      update();
      // reset password doctor :
      if (Auth!.getString('user') == 'active_doctor') {
        change_password_for_user('reset-password-doctor');
      }
      // reset password teacher :
      else if (Auth!.getString('user') == 'active_teacher') {
        change_password_for_user('reset-password-teacher');
      }
      // reset password student :
      else if (Auth!.getString('user') == 'active_student') {
        change_password_for_user('reset-password-student');
      }
    }
  }

  Widget toggleOldPassWord() {
    return IconButton(
      onPressed: () {
        isSecurePassword = !isSecurePassword;
        update(["pass"]);
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

  Widget toggleNewPassWord() {
    return IconButton(
      onPressed: () {
        isSecureNewPassword = !isSecureNewPassword;
        update(["new_pass"]);
      },
      icon: isSecureNewPassword
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

  Widget toggleNewConfirmPassWord() {
    return IconButton(
      onPressed: () {
        isSecureConfirmNewPassword = !isSecureConfirmNewPassword;
        update(["confirm_new_pass"]);
      },
      icon: isSecureConfirmNewPassword
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
}
