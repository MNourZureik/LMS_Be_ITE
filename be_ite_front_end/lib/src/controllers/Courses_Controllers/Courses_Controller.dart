// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/models/api.dart';

class CoursesController extends GetxController {
  bool isVideoSection = true;
  bool isDiscryption = false;

  final List<String> ids = [
    'ilmZwseiO-k',
    'MQKfZapjGlc',
    'KLH2RuNI5yc',
    '9f34AD44oc',
  ];
  List name = [
    'Python',
  ];
  List<String> path = [
    'assets/images/python.png',
  ];

  List desc = [
    'videos : 4',
  ];
  List auther = [
    'Mouhmad alDsoki',
  ];
  List<Color> colors = [
    const Color.fromARGB(255, 216, 251, 118),
  ];

  List subtitle = [
    '1 min 21 sec',
    '15 min 14 sec',
    '35 min 3 sec',
    '1 hour 7 min 24 sec',
  ];
  List videos = [
    'Introduction',
    'Python Basics',
    'Variables and Data Tybe',
    'Python Basics',
  ];

  @override
  void onInit() async {
    // try {
    //   final response = await Api.get_request("show-courses");
    //   log(response["data"].toString());
    //   for (int i = 0; i < response["data"].length; i++) {
    //     final course = response["data"][i];
    //     name.add(course["course_name"]);
    //     auther.add(course["auther_name"]);
    //     desc.add(course["discreption"]);
    //     for (int j = 0; j < course["links"].length; j++) {
    //       final video = course["links"][j];
    //       videos.add(video["video_title"]);
    //       subtitle.add(video["video_time"]);
    //       ids.add(video["video_url"]);
    //     }
    //     String? photo = await FlutterDownloader.enqueue(
    //       savedDir: "",
    //         url:
    //             "https://www.udemy.com/staticx/udemy/images/v7/logo-udemy-inverted.svg");
    //     if (photo != null) {
    //       //path.add(photo.path);
    //     }
    //   }
    //   int i = m.Random().nextInt(6);
    //   colors.add(Color(i));
    // } catch (e) {
    //   log(e.toString());
    // }
    super.onInit();
  }
}
