// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, unused_field

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/src/models/api.dart';
import 'package:public_testing_app/src/widgets/ElevatedButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/main.dart';
import 'package:http/http.dart' as http;
import '../../models/SnackBar.dart';

class DrawersController extends GetxController {
  File? image;
  final Form_key = GlobalKey<FormState>();
  Widget? circleImage;
  File? photo_path;
  // Called when the user click SAVE for saving changes if its found :
  void SavePhoto() {
    if (Form_key.currentState!.validate()) {
      Form_key.currentState!.save();
      circleImage = const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
      update(['circle_image']);

      if (Auth!.getString('user') == "active_student") {
        _uploadUserImage("Edit-student-photo");
      } else if (Auth!.getString('user') == "active_doctor") {
        _uploadUserImage("Edit-doctor-photo");
      } else if (Auth!.getString('user') == "active_teacher") {
        _uploadUserImage("Edit-teacher-photo");
      }
      if (appData!.getString("user_photo_localy") != null) {
        appData!
            .setString("user_photo", appData!.getString("user_photo_localy")!);
      }
    } else {
      return;
    }
  }

  // function called when the student Change his picture and save changes :
  Future<void> _uploadUserImage(String user_type) async {
    try {
      if (appData!.getString('user_photo_localy') == '') {
        circleImage = null;
        update(['circle_image']);
        Get.back();
        return;
      }

      var response = await Api.post_request_with_files(
          user_type, null, 'photo', image!.path);

      if (response.statusCode == 200) {
        //? Photo updated successfully
        circleImage = null;
        update(['circle_image']);
        Get.back();
        Themes.get_notification_info('check', 'Changes Saved', 'Successfully!');
      } else {
        //? Handle error (e.g., display an error message to the user)
        Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Viewing Bottom Sheet :
  Future PickImageFromSource(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.secondaryContainer,
          Themes.colorScheme.primaryContainer),
      context: context,
      builder: (ctx) => BottomSheet(),
    );
  }

  // function for selecting image from the user device depending on speciefic source :
  void selectImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(source: source);
    if (img != null) {
      image = File(img.path);
      appData!.setString('user_photo_localy', image!.path);
      update(['image']);
    }
  }

  // bottom Sheet to choose image source : (Gallery || Camera):
  Widget BottomSheet() {
    return Container(
      width: Get.mediaQuery.size.width,
      height: 180,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              indent: Get.mediaQuery.size.width / 2.5,
              endIndent: Get.mediaQuery.size.width / 2.5,
              thickness: 2,
            ),
          ),
          Text(
            'Choose Your Profile Photo',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyElevetedButton(
                  onTap: () => selectImage(ImageSource.camera),
                  width: 10,
                  height: 20,
                  BackColor: Themes.getColor(
                      Themes.darkColorScheme.onPrimaryContainer,
                      Themes.colorScheme.onSecondaryContainer),
                  widget: Row(
                    children: [
                      Text(
                        'camera',
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: Themes.getColor(Colors.black, Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Iconsax.camera,
                        color: Themes.getColor(Colors.black, Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyElevetedButton(
                  onTap: () => selectImage(ImageSource.gallery),
                  width: 10,
                  height: 20,
                  BackColor: Themes.getColor(
                      Themes.darkColorScheme.onPrimaryContainer,
                      Themes.colorScheme.onSecondaryContainer),
                  widget: Row(
                    children: [
                      Text(
                        'gallery',
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: Themes.getColor(Colors.black, Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Icon(
                        Iconsax.image,
                        color: Themes.getColor(Colors.black, Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void onInit() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Themes.getColor(
            Themes.darkColorScheme.primary, Themes.colorScheme.primary),
        systemNavigationBarColor: Themes.getColor(
            Themes.darkColorScheme.primary, Themes.colorScheme.primary),
      ),
    );
    appData!.setString('user_photo_localy', '');
    super.onInit();
  }

  // FETCH user picture :
  void getUserPhoto(String user_type) async {
    if (appData!.getString("user_photo") == null ||
        appData!.getString("user_photo") == '') {
      try {
        final decodedResponse = await Api.get_request(user_type);
        if (decodedResponse["data"] != null) {
          String updatedUrl =
              decodedResponse["data"].replaceFirst("127.0.0.1", "10.0.2.2");

          try {
            photo_path = await FileDownloader.downloadFile(
              url: updatedUrl,
              name: updatedUrl.substring(36),
              subPath: 'user_image',
              onProgress: (String? fileName, double progress) {
                log('FILE fileName HAS PROGRESS $progress');
              },
              onDownloadCompleted: (String path) {
                log('FILE DOWNLOADED TO PATH: $path');
              },
              onDownloadError: (String error) {
                Themes.no_internet_connection();
              },
            );
          } catch (e) {
            log(e.toString());
          }
          if (photo_path != null) {
            appData!.setString('user_photo', photo_path!.path);
          } else {
            appData!.setString('user_photo', '');
          }
        } else {
          appData!.setString('user_photo', '');
        }
        update(['user_picture']);
      } catch (e) {
        log(e.toString());
      }
    }
  }
}
