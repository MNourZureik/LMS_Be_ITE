import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/Student_Subjects_Controller.dart';

import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/fourth_Page/FilesTypes.dart';

class ImagesCard extends StatelessWidget {
  const ImagesCard(
      {super.key,
      required this.index,
      required this.subject_type,
      required this.subject_name,
      required this.year});

  final int index;
  final String subject_type;
  final String subject_name;
  final int year;
  @override
  Widget build(BuildContext context) {
    final HomeController h_controller = Get.find();
    StudentSubjectsController? student_controller;
    if (Auth!.getString("user") == "active_student") {
      student_controller = Get.put(StudentSubjectsController());
    }

    return Auth!.getString("user") != "active_student"
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            child: GetBuilder<HomeController>(
              id: 'download_image[$index]',
              builder: (controller) {
                return Dismissible(
                  key: ValueKey(DateTime.now()),
                  onDismissed: (direction) {
                    controller.delete_file(
                        controller.files_ids[index], index, Files_Types.image);
                  },
                  background: Container(
                    width: Get.size.width,
                    height: Get.size.width - 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        width: 2,
                        color: Themes.getColor(
                          Themes.darkColorScheme.primary,
                          Themes.colorScheme.primary,
                        ),
                      ),
                      color: const Color(0xffff5500).withAlpha(150),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          "delete",
                          style: Get.textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (appData!.getString(
                                  "photo[${h_controller.files_ids[index]}]") !=
                              null) {
                            showImageViewer(
                              context,
                              FileImage(File(appData!.getString(
                                  "photo[${h_controller.files_ids[index]}]")!)),
                              useSafeArea: true,
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                              barrierColor: Colors.white,
                            );
                          }
                        },
                        child: Container(
                          width: Get.size.width,
                          height: Get.size.width - 150,
                          decoration: BoxDecoration(
                            image: appData!.getString(
                                        "photo[${h_controller.files_ids[index]}]") !=
                                    null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(appData!.getString(
                                          "photo[${h_controller.files_ids[index]}]")!),
                                    ),
                                  )
                                : null,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              width: 2,
                              color: Themes.getColor(
                                Themes.darkColorScheme.primary,
                                Themes.colorScheme.primary,
                              ),
                            ),
                            color: const Color(0xff555555).withAlpha(150),
                          ),
                          child: appData!.getString(
                                      "photo[${h_controller.files_ids[index]}]") ==
                                  null
                              ? GetBuilder<HomeController>(
                                  id: 'is_image_downloaded[$index]',
                                  builder: (context) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Center(
                                        child: CircleAvatar(
                                          radius: 25,
                                          child: InkWell(
                                            onTap: () => h_controller
                                                .download_image(index),
                                            child: h_controller
                                                    .download_circle ??
                                                const Icon(Icons
                                                    .file_download_outlined),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.black45,
                          ),
                          height: 50,
                          width: Get.size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  h_controller.files_names[index],
                                  style: Get.textTheme.titleMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
            child: GetBuilder<HomeController>(
              id: 'download_image[$index]',
              builder: (controller) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        if (appData!.getString(
                                "photo[${h_controller.files_ids[index]}]") !=
                            null) {
                          showImageViewer(
                            context,
                            FileImage(File(appData!.getString(
                                "photo[${h_controller.files_ids[index]}]")!)),
                            useSafeArea: true,
                            swipeDismissible: true,
                            doubleTapZoomable: true,
                            barrierColor: Colors.white,
                          );
                        }
                      },
                      child: Container(
                        width: Get.size.width,
                        height: Get.size.width - 150,
                        decoration: BoxDecoration(
                          image: appData!.getString(
                                      "photo[${h_controller.files_ids[index]}]") !=
                                  null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(appData!.getString(
                                        "photo[${h_controller.files_ids[index]}]")!),
                                  ),
                                )
                              : null,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            width: 2,
                            color: Themes.getColor(
                              Themes.darkColorScheme.primary,
                              Themes.colorScheme.primary,
                            ),
                          ),
                          color: const Color(0xff555555).withAlpha(150),
                        ),
                        child: appData!.getString(
                                    "photo[${h_controller.files_ids[index]}]") ==
                                null
                            ? GetBuilder<HomeController>(
                                id: 'is_image_downloaded[$index]',
                                builder: (context) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 25,
                                        child: InkWell(
                                          onTap: () => h_controller
                                              .download_image(index),
                                          child: h_controller.download_circle ??
                                              const Icon(
                                                  Icons.file_download_outlined),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Colors.black45,
                        ),
                        height: 50,
                        width: Get.size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Text(
                                textAlign: TextAlign.center,
                                h_controller.files_names[index],
                                style: Get.textTheme.titleMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
  }
}
