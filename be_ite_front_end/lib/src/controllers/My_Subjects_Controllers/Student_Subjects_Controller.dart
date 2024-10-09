// ignore_for_file: await_only_futures, unused_field

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';
import 'package:http/http.dart' as http;
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/api.dart';
import 'package:public_testing_app/src/views/src/Home/fourth_Page/FilesTypes.dart';

class StudentSubjectsController extends GetxController {
  List<int> year_id = [1, 2, 3];
  dynamic student_subjects = [];
  Widget? circle_for_files;
  Files_Types ctrl_type = Files_Types.adds;
  HomeController controller = Get.put(HomeController());
  String SelectedChoice = 'TP';

  // this function for removing the subjects choosed from student to be hisSubjects :
  void removeFromMySubjects(int subject_id) async {
    try {
      final data = {
        "subject_id": '$subject_id',
      };
      final decodedResponse =
          await Api.post_request_with_token("remove-from-my-subjects", data);
      //? subject added successfully :
      if (decodedResponse["status"] == 200) {
        Themes.get_notification_info(
            'check', 'Subject Deleted', 'Successfully!');
      }
      //? SOMETHING went wrong :
      else {
        Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Fetch student subjects :
  void getStudentSubjects() async {
    try {
      final decodedResponse = await Api.get_request("student-subjects");
      if (decodedResponse["status"] == 200) {
        student_subjects = decodedResponse["data"];
      }
      update(["subjects"]);
      controller.update(['doctor_upload']);
    } catch (e) {
      if (!Get.isSnackbarOpen) {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
      }
    }
  }

  Future dialog_for_adding_subject_to_MySubjects(BuildContext context,
      int subject_th_id, int? subject_pr_id, int index) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation_1, animation_2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, widget) {
        return ShowDialog(subject_th_id, subject_pr_id, index, a1, a2);
      },
    );
  }

  Widget ShowDialog(int subject_th_id, int? subject_pr_id, int index,
      Animation<double> a1, Animation<double> a2) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: AlertDialog(
          backgroundColor: Themes.getColor(
              Themes.darkColorScheme.primaryContainer,
              Themes.colorScheme.primaryContainer),
          content: SizedBox(
            width: Get.size.width - 100,
            height: Get.size.width - 180,
            child: GetBuilder<StudentSubjectsController>(
              id: 'add_TP_or_T',
              builder: (controller) {
                return Stack(
                  children: [
                    // title :
                    Text(
                      'remove My Subject :',
                      style: Get.textTheme.titleLarge!.copyWith(fontSize: 25),
                    ),
                    // TP :
                    Positioned(
                      top: 55,
                      child: RadioMenuButton(
                        value: 'P',
                        groupValue: SelectedChoice,
                        onChanged: (value) {
                          SelectedChoice = value!;
                          update(['add_TP_or_T']);
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Themes.getColor(
                                Themes.darkColorScheme.primaryContainer,
                                Themes.colorScheme.primaryContainer),
                          ),
                        ),
                        child: Text(
                          'Practical.',
                          style:
                              Get.textTheme.titleLarge!.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                    // P :
                    Positioned(
                      top: 110,
                      child: RadioMenuButton(
                        value: 'TP',
                        groupValue: SelectedChoice,
                        onChanged: (value) {
                          SelectedChoice = value!;
                          update(['add_TP_or_T']);
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Themes.getColor(
                                Themes.darkColorScheme.primaryContainer,
                                Themes.colorScheme.primaryContainer),
                          ),
                        ),
                        child: Text(
                          'Theoritical.',
                          style:
                              Get.textTheme.titleLarge!.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                    // add button :
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 2,
                              offset: Offset(0, 0.5),
                            )
                          ],
                          color: Themes.colorScheme.onPrimaryContainer
                              .withOpacity(.8),
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
                              if (SelectedChoice == "TP") {
                                removeFromMySubjects(subject_th_id);
                                student_subjects
                                    .remove(student_subjects[index]);
                                update(["subjects"]);
                                Get.back();
                              } else if (SelectedChoice == "P") {
                                removeFromMySubjects(subject_pr_id!);
                                student_subjects
                                    .remove(student_subjects[index]);
                                getStudentSubjects();
                                update(["subjects"]);
                                Get.back();
                              }
                            },
                            child: Text(
                              'remove',
                              style: Get.textTheme.titleLarge!
                                  .copyWith(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // cancel button :
                    Positioned(
                      bottom: 0,
                      right: 90,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 2,
                              offset: Offset(0, 0.5),
                            )
                          ],
                          color: Themes.colorScheme.onPrimaryContainer
                              .withOpacity(.8),
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
              },
            ),
          ),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  void onInit() {
    getStudentSubjects();
    super.onInit();
  }
}
