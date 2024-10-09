import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/api.dart';
import 'package:public_testing_app/src/views/src/Home/fourth_Page/FilesTypes.dart';
import 'package:public_testing_app/src/widgets/TextFormField.dart';

class OtherusersSubjectsController extends GetxController {
  List<Map<String, dynamic>> other_user_subjects_information = [];
  Widget? fail_request;
  File? file;
  Widget? Circle;
  final form_key = GlobalKey<FormState>();
  final body = TextEditingController();

  @override
  void onInit() {
    appData!.setBool("is_my_subjects", false);
    if (Auth!.getString("user") == "active_doctor") {
      other_user_subjects_information = [];
      get_Other_User_Subjects("doctor-subjects-theoretical");
      get_Other_User_Subjects("doctor-subjects-practical");
    } else if (Auth!.getString("user") == "active_teacher") {
      other_user_subjects_information = [];
      get_Other_User_Subjects("teacher-subjects");
    }
    super.onInit();
  }

  // fetching doctor or teacher subjects who is responsible for :
  void get_Other_User_Subjects(String subjects_type) async {
    try {
      final decodedResponse = await Api.get_request(subjects_type);
      if (decodedResponse["status"] == 200) {
        for (int i = 0; i < decodedResponse["data"].length; i++) {
          final Map<String, dynamic> other_user_subject =
              decodedResponse["data"][i];

          other_user_subjects_information.add(other_user_subject);
        }
      } else {
        fail_request = const Center(
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/images/error-404.png"),
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text("Connection Failed !"),
            ],
          ),
        );
      }
    } catch (e) {
      fail_request = const Center(
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/images/error-404.png"),
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text("Connection Failed !"),
          ],
        ),
      );
      e.toString();
    }
    update(["other_user_subjects"]);
  }

  // Pick Files or images then upload it :
  void upload_files(BuildContext context, String type, int subject_id,
      String subject_type, String subject_name, int year) async {
    String? path;
    String? name;
    if (type == "pdf") {
      try {
        path = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'], // Allow only PDF files
        ).then(
          (value) {
            name = value!.files.first.name;
            return value.files.first.path;
          },
        );
        if (path != null && name != null) {
          file = File(path);
          if (Auth!.getString("user") == "active_doctor") {
            upload_file(file!, type, subject_id.toString(), name!, subject_type,
                subject_name, year, "upload_file_doctor");
          } else if (Auth!.getString("user") == "active_teacher") {
            upload_file(file!, type, subject_id.toString(), name!, subject_type,
                subject_name, year, "upload_file_teacher");
          }
        }
      } catch (e) {
        print('Error picking PDF file: $e');
      }
    } else if (type == "image") {
      try {
        path = await FilePicker.platform
            .pickFiles(
          type: FileType.image,
        )
            .then(
          (value) {
            name = value!.files.first.name;
            return value.files.first.path;
          },
        );
        if (path != null && name != null) {
          file = File(path);
          if (Auth!.getString("user") == "active_doctor") {
            upload_file(file!, type, subject_id.toString(), name!, subject_type,
                subject_name, year, "upload_file_doctor");
          } else if (Auth!.getString("user") == "active_teacher") {
            upload_file(file!, type, subject_id.toString(), name!, subject_type,
                subject_name, year, "upload_file_teacher");
          }
        }
      } catch (e) {
        print('Error picking PDF file: $e');
      }
    } else if (type == "adds") {
      dialog_for_publish_notification(context, subject_id);
    }
  }

  Future dialog_for_publish_notification(
      BuildContext context, int subject_id) async {
    showModalBottomSheet(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.secondaryContainer,
          Themes.colorScheme.primaryContainer),
      context: context,
      builder: (ctx) => BottomSheet(subject_id),
    );
  }

  Widget BottomSheet(int subject_id) {
    return Stack(
      children: [
        // title :
        Positioned(
          left: 20,
          top: 20,
          child: Text(
            'Enter Notification :',
            style: Get.textTheme.titleLarge!.copyWith(fontSize: 25),
          ),
        ),
        // body field :
        Positioned(
          top: 80,
          child: SizedBox(
            width: Get.width,
            height: 75,
            child: Form(
              key: form_key,
              child: MyTextFormField(
                label: "enter notification to publish ...",
                validate: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "content required";
                  }
                },
                save: (value) {
                  body.text = value!;
                },
              ),
            ),
          ),
        ),
        // add button :
        Positioned(
          top: 180,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  blurRadius: 2,
                  offset: Offset(0, 0.5),
                )
              ],
              color: Themes.colorScheme.onPrimaryContainer.withOpacity(.8),
              border: Border.all(
                width: 2,
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Themes.darkColorScheme.primary
                    : Colors.blue,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            width: Get.size.width / 5,
            height: Get.size.height / 19,
            child: Center(
              child: InkWell(
                onTap: () {
                  if (form_key.currentState!.validate()) {
                    form_key.currentState!.save();
                    publish_notification(subject_id, body.text);
                    Get.back();
                    body.text = '';
                  }
                },
                child: Text(
                  'publish',
                  style: Get.textTheme.titleLarge!
                      .copyWith(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        // cancel button :
        Positioned(
          top: 180,
          right: 100,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  blurRadius: 2,
                  offset: Offset(0, 0.5),
                )
              ],
              color: Themes.colorScheme.onPrimaryContainer.withOpacity(.8),
              border: Border.all(
                width: 2,
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Themes.darkColorScheme.primary
                    : Colors.blue,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            width: Get.size.width / 5,
            height: Get.size.height / 19,
            child: Center(
              child: InkWell(
                onTap: () => Get.back(),
                child: Text(
                  'cancel',
                  style: Get.textTheme.titleLarge!
                      .copyWith(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // General Upload File :
  void upload_file(File file, String type, String subject_id, String file_name,
      String subject_type, String subject_name, int year, String url) async {
    try {
      final data = {
        "file_name": file_name,
        "file_type": type.toUpperCase(),
        "subject_id": subject_id,
      };
      var response =
          await Api.post_request_with_files(url, data, "file", file.path);

      // Handle the response (check for success or errors)
      if (response.statusCode == 200) {
        final HomeController controller = Get.find();
        controller.get_files_names_for_type(
          type == "pdf" ? Files_Types.pdf : Files_Types.image,
          subject_type,
          subject_name,
          year,
          int.parse(subject_id),
          true,
          file,
          null,
        );
        Themes.get_notification_info(
            'check', '${type.toUpperCase()} Uploaded', 'Successfully!');
      } else {
        Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void publish_notification(int subject_id, String body) async {
    HomeController controller = Get.put(HomeController());
    try {
      final data = {
        "subject_id": "$subject_id",
        "body": body,
      };
      final response =
          await Api.post_request_with_token("add-notifications-subject", data);
      if (response["status"] == 200) {
        Themes.get_notification_info(
            "check", "Notification Published", "Successfully");
        controller.get_notifications(subject_id, null, null, null, null);
      } else {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
