// ignore_for_file: missing_required_param

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import '../../views/src/AI_Assistant/Message.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AIController extends GetxController {
  final TextEditingController controller = TextEditingController();
  List<Message> messages = [];
  String state = "";
  Widget? loading;
  List<ConnectivityResult> connectivityResult = [];
  Connectivity connectivity = Connectivity();
  bool isConnect = false;

  void checkConnection(List<ConnectivityResult> connectivityResult) async {
    connectivityResult = [];
    connectivityResult = await (connectivity.checkConnectivity());
    log(connectivityResult.toString());
    appData!.setString("connection_result", connectivityResult.toString());
    update(["is_connected"]);
    if (Get.isSnackbarOpen &&
        !connectivityResult.contains(ConnectivityResult.none)) {
      Get.closeAllSnackbars();
    }
    final controller = Get.put(HomeController());
    controller.onInit();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      state = "offline";
      update(["state"]);
      Themes.no_internet_connection();
    } else {
      state = "online";
      update(["state"]);
      // if (Get.isSnackbarOpen) {
      //   Get.closeAllSnackbars();
      // }
    }
  }

  void checkState(List<ConnectivityResult> connectivityResult) async {
    connectivityResult = [];
    connectivityResult = await (connectivity.checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      isConnect = false;
      state = "offline";
      update(["state"]);
    } else {
      isConnect = true;
      state = "online";
      update(["state"]);
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  callGiminiModel() async {
    try {
      if (controller.text.isNotEmpty) {
        messages.add(
          Message(
            text: controller.text,
            isUser: true,
          ),
        );
        final loading = ListTile(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Image(
                    image: AssetImage('assets/images/robot.png'),
                    width: 15,
                    height: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Lottie.asset(
                      'assets/json/loading.json',
                      width: 100,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        messages.add(Message(loading: loading, text: '', isUser: false));

        update();
      }

      final model = GenerativeModel(
        model: 'gemini-1.0-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY']!,
      );

      final prompt = controller.text;
      controller.clear();
      update();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      loading = null;
      messages.removeWhere((item) => item.loading != null);

      update();

      messages.add(
        Message(
          text: response.text!,
          isUser: false,
        ),
      );
      update();
    } catch (e) {
      messages.removeAt(messages.length - 1);
      checkState(connectivityResult);
      if (isConnect == false) {
        messages.add(Message(
            text: 'Connect to the internet then try again', isUser: false));
      } else {
        messages.add(Message(
            text: 'Something went wrong try changing vpn to japan!',
            isUser: false));
      }
      update();
    }
  }

  Future<bool> onWillPop() async {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    return true;
  }

  @override
  void onInit() {
    checkState(connectivityResult);
    connectivity.onConnectivityChanged.listen(checkConnection);
    super.onInit();
  }
}
