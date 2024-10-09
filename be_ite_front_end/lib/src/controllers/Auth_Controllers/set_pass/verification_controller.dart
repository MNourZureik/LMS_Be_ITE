// ignore_for_file: non_constant_identifier_names , file_names, unused_local_variable, missing_required_param

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/models/api.dart';
import 'package:public_testing_app/src/widgets/ElevatedButton.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';
import 'package:public_testing_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/Themes.dart';
//import 'package:public_testing_app/main.dart';

class VerificationController extends GetxController {
  final Form_Key = GlobalKey<FormState>();
  Timer? timer;
  int remainingSeconds = 1;
  int seconds = 60;
  int counter = 0;
  RxString time = '00:00'.obs;
  Widget? circle;
  bool willPopScope = false;

  //Controllers :
  final code = TextEditingController();
  String verificationID = '';

  void verify_user_code(String user_type, String user_url) async {
    try {
      // email url :
      final data = {
        'email': Auth!.getString('email'),
        'verificationCode': code.text,
      };

      // decoded response :
      final decodedResponse =
          await Api.post_request_without_token(user_url, data);

      // verfication code is true :
      if (decodedResponse["status"] == 200) {
        if (Auth!.getString('user') == 'active_$user_type') {
          Auth!.setString('user', 'non_active_$user_type');
        }
        Auth!.setString("token", "${decodedResponse["data"]["token"]}");
        circle = null;
        update(["circleIndicater"]);
        Get.offNamed('RegisterPassPageScreen');

       if(user_type == "student"){
         final String? token = await FirebaseMessaging.instance.getToken();
        final data = {
          "fcm_token": token,
        };
        Api.post_request_with_token("register-fcm-token", data);
        }

        //! send device key
      }
      //verfication code is false :
      else if (decodedResponse["status"] == 201) {
        Themes.get_notification_info('cross', 'You entered a wrong', 'code!');
        circle = null;
        update(["circleIndicater"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void onSave() async {
    if (Form_Key.currentState!.validate()) {
      Form_Key.currentState!.save();

      // circle indicater :
      circle = const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      );
      update(["circleIndicater"]);

      // teacher verification code :
      if (Auth!.getString('user') == 'non_active_teacher' ||
          Auth!.getString('user') == 'active_teacher') {
        verify_user_code('teacher', 'log_in_teacher_by_code');
      }
      // doctor verification code :
      else if (Auth!.getString('user') == 'non_active_doctor' ||
          Auth!.getString('user') == 'active_doctor') {
        verify_user_code('doctor', 'log_in_doctor_by_code');
      }
      // student verification code :
      else if (Auth!.getString('user') == 'non_active_student' ||
          Auth!.getString('user') == 'active_student') {
        verify_user_code('student', 'log_in_student_by_code');
      }
    } else {
      return;
    }
  }

  void ResendCode() async {
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

  void startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (remainingSeconds != -1) {
          int min = remainingSeconds ~/ 60;
          int sec = remainingSeconds % 60;
          time.value =
              '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
          remainingSeconds--;
        } else {
          willPopScope = true;
          update(['will_pop_scope']);
          timer.cancel();
          update(['resend_code']);
        }
      },
    );
  }

  @override
  void onReady() {
    if (counter == 0) {
      startTimer(seconds);
    } else if (counter == 1) {
      startTimer(seconds * 5);
    } else if (counter == 2) {
      startTimer(seconds * 10);
    } else if (counter == 3) {
      startTimer(seconds * 30);
    } else {
      Get.defaultDialog(
        title: '',
        content: const Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: CircleAvatar(
                radius: 48,
                child: Image(
                  image: AssetImage('assets/images/cross.png'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Too many attempts reLogin please!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        contentPadding: const EdgeInsets.only(bottom: 15),
        confirm: MyElevetedButton(
          label: 'OK',
          onTap: () {
            Get.offAllNamed('EmailPageScreen');
          },
          width: 7,
          height: 25,
          BackColor: Themes.getColor(
            Themes.darkColorScheme.onSecondary,
            Themes.colorScheme.onSecondary,
          ),
        ),
        backgroundColor: Themes.getColor(
          Themes.darkColorScheme.onPrimary,
          Themes.colorScheme.onPrimary,
        ),
        barrierDismissible: false,
      );
    }
    super.onReady();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  @override
  void dispose() {
    code.dispose();
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
