import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/OtherUsers_Subjects_Controller.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/Student_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/first_Page/home.dart';
import 'FilesTypes.dart';

class FilestypesCard extends StatelessWidget {
  FilestypesCard({
    super.key,
    required this.type,
    required this.index,
    required this.subject_type,
    required this.subject_name,
    required this.year,
    this.subject_id,
    this.index_for_student,
  });

  final Files_Types type;
  final int index;
  final String subject_type;
  final String subject_name;
  final int year;
  int? subject_id;
  int? index_for_student;

  @override
  Widget build(BuildContext context) {
    final Home_Controller = Get.put(HomeController());
    StudentSubjectsController? student_controller;
    OtherusersSubjectsController? other_controller;
    if (Auth!.getString("user") == "active_student") {
      student_controller = Get.put(StudentSubjectsController());
    } else {
      other_controller = Get.put(OtherusersSubjectsController());
    }

    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);

    final go_to_file_screen = InkWell(
      onTap: () {
        //! doctor notifications :
        if (type == Files_Types.adds &&
            (Auth!.getString("user") == "active_doctor" ||
                Auth!.getString("user") == "active_teacher")) {
          Home_Controller.get_notifications(
              subject_id!, type, subject_name, year, subject_type);
          return;
        }
        //! student notifications :
        if (type == Files_Types.adds &&
            Auth!.getString("user") == "active_student" &&
            appData!.getBool("is_my_subjects") == true) {
          log(student_controller!.student_subjects[index_for_student!]
              .toString());
          try {
            int id = 0;
            if (subject_type == "Theoritical") {
              id = student_controller.student_subjects[index_for_student!]
                  ["id_theo"];
            } else if (subject_type == "Practical") {
              id = student_controller.student_subjects[index_for_student!]
                  ["id_pra"];
            }

            Home_Controller.get_notifications(
                id, type, subject_name, year, subject_type);
          } catch (e) {
            Themes.get_notification_info("cross", "Something Went", "Wrong!");
          }
          return;
        } else if (type == Files_Types.adds &&
            Auth!.getString("user") == "active_student" &&
            appData!.getBool("is_my_subjects") == false) {
          int id = 0;
          if (subject_type == "Theoritical") {
            final index =
                Home_Controller.name_of_th_subjects.indexOf(subject_name);

            id = Home_Controller.subjects_theoritical_ids[index];
          } else if (subject_type == "Practical") {
            final index =
                Home_Controller.name_of_pr_subjects.indexOf(subject_name);

            id = Home_Controller.subjects_practical_ids[index];
          }
          Home_Controller.get_notifications(
              id, type, subject_name, year, subject_type);
        }
        if (appData!.getBool("is_my_subjects") == false) {
          Home_Controller.get_files_names_for_type(
            type,
            subject_type,
            subject_name,
            year,
            Auth!.getString("user") == "active_student" ? null : subject_id,
            false,
            null,
            null,
          );
        } else {
          int id = 0;
          if (subject_type == "Theoritical") {
            id = student_controller!.student_subjects[index_for_student!]
                ["id_theo"];
          } else if (subject_type == "Practical") {
            id = student_controller!.student_subjects[index_for_student!]
                ["id_pra"];
          }
          Home_Controller.get_files_names_for_type(
            type,
            subject_type,
            subject_name,
            year,
            Auth!.getString("user") == "active_student" ? null : subject_id,
            false,
            null,
            id,
          );
        }
      },
      child: const Icon(
        size: 30,
        Iconsax.arrow_right,
        color: Colors.white,
      ),
    );

    return Stack(
      children: [
        // Files Types Cards :
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: is_Dark!.getString('is_dark') == 'true'
                  ? [
                      const Color(0xff83D5C1),
                      const Color(0xff83D5C1).withGreen(200),
                      const Color(0xff606871),
                    ]
                  : [
                      const Color(0xff64ACFF),
                      const Color(0xff85AAD5),
                      const Color(0xff606871),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              width: 4,
              color: is_Dark!.getString('is_dark') == 'true'
                  ? Colors.green
                  : Colors.blue,
            ),

            color: Colors.white, // Example color
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        // Files Types Images :
        Positioned(
          left: 15,
          top: 50,
          child: Image(
            image: AssetImage(Home_Controller.files_types_photos[index]),
            width: 70,
            height: 70,
          ),
        ),
        // Files Types names :
        Positioned(
          top: 10,
          left: 20,
          child: Text(
            '${Home_Controller.files_types_names[index]} :',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        // Files Types Button Navigate to Files Screen :
        Positioned(
            left: 110,
            top: 120,
            child: GetBuilder<HomeController>(
              id: 'go_to_files',
              init: HomeController(),
              builder: (context) {
                return Container(
                  padding: (appData!.getBool("is_my_subjects") == false
                              ? Home_Controller.circle_for_files != null
                              : student_controller!.circle_for_files != null) &&
                          (appData!.getBool("is_my_subjects") == false
                              ? Home_Controller.ctrl_type == type
                              : student_controller!.ctrl_type == type)
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 2,
                        offset: Offset(0, 0.5),
                      )
                    ],
                    color:
                        Themes.colorScheme.onPrimaryContainer.withOpacity(.8),
                    border: Border.all(
                      width: 2,
                      color: is_Dark!.getString('is_dark') == 'true'
                          ? Themes.darkColorScheme.primary
                          : Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: width / 8,
                  height: height / 19,
                  //! update every subject :
                  child: (appData!.getBool("is_my_subjects") == false
                          ? Home_Controller.ctrl_type == type
                          : student_controller!.ctrl_type == type)
                      ? (appData!.getBool("is_my_subjects") == false
                              ? Home_Controller.circle_for_files
                              : student_controller!.circle_for_files) ??
                          go_to_file_screen
                      : go_to_file_screen,
                );
              },
            )),
      ],
    );
  }
}
