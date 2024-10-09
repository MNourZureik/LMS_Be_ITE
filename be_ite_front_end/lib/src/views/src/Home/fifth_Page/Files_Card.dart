import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/Student_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/Introduction/IntroductionScreen.dart';
import 'package:public_testing_app/src/views/src/Home/fifth_Page/OpenFile.dart';
import 'package:public_testing_app/src/views/src/Home/fourth_Page/FilesTypes.dart';

class FilesCard extends StatelessWidget {
  const FilesCard(
      {super.key,
      required this.index,
      required this.type,
      required this.subject});

  final int index;
  final String type;
  final String subject;

  @override
  Widget build(BuildContext context) {
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);
    final HomeController controller = Get.find();
    StudentSubjectsController? student_controller;
    if (Auth!.getString("user") == "active_student") {
     student_controller = Get.put(StudentSubjectsController());
    }

    Widget added_to_saved_files = const Icon(
      Icons.check,
      size: 30,
      color: Colors.green,
    );
    Widget add_to_saved_files = InkWell(
      onTap: () {
        controller.add_to_saved_files(controller.files_ids[index], index);
      },
      child: const Icon(
        Iconsax.add_circle,
        size: 30,
        color: Colors.white,
      ),
    );

    Widget open = InkWell(
      onTap: () {
        String path;
        if (Auth!.getString("user") == "active_student") {
          int i = controller.files_ids[index];
          path = appData!.getString("file[$type][$i]")!;
        } else {
          path = appData!
              .getString("file[$type][${controller.files_ids[index]}]")!;
        }

        Get.to(
          () => Openfile(
            file_path: path,
          ),
        );
        if (Auth!.getString("user") == "active_student") {
          String name = controller.files_names[index];

          controller.add_to_recent_files(name, path);
        }
      },
      child: const Icon(
        Iconsax.folder_open,
        size: 30,
        color: Colors.white,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Themes.getColor(
                Themes.darkColorScheme.primaryContainer.withOpacity(.7),
                Colors.blue.withOpacity(.5),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              border: Border.all(
                color: Themes.getColor(
                    Themes.darkColorScheme.primary, Themes.colorScheme.primary),
                width: 3,
              ),
            ),
            width: width,
            height: height / 12,
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  left: 10,
                  child: Text(
                    '${index + 1} . ',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 15),
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 30,
                  child: SizedBox(
                    width: 230,
                    child: SingleChildScrollView(
                      child: Text(
                        controller.files_names[index],
                        style: Get.textTheme.titleLarge!.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GetBuilder<HomeController>(
                    id: 'download[$index]',
                    init: HomeController(),
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: controller.download_circle == null
                            ? width / 8
                            : width / 6,
                        height: width / 8,
                        decoration: BoxDecoration(
                          color: Themes.colorScheme.onPrimaryContainer,
                          border: Border.all(
                            width: 3,
                            color: Themes.getColor(Colors.white, Colors.white),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Themes.getColor(Colors.green, Colors.blue),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: appData!.getString(
                                    "file[$type][${controller.files_ids[index]}]") ==
                                null
                            ? controller.download_circle ??
                                InkWell(
                                  onTap: () {
                                    controller.download_file(index, type,
                                        subject, controller.files_names[index]);
                                  },
                                  child: const Icon(
                                    Iconsax.document_download,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )
                            : open,
                      );
                    },
                  ),
                ),
                if (Auth!.getString("user") != "active_student")
                  Positioned(
                    right: 70,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: controller.download_circle == null
                          ? width / 8
                          : width / 6,
                      height: width / 8,
                      decoration: BoxDecoration(
                        color: Themes.colorScheme.onPrimaryContainer,
                        border: Border.all(
                          width: 3,
                          color: Themes.getColor(Colors.white, Colors.white),
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Themes.getColor(Colors.green, Colors.blue),
                            blurStyle: BlurStyle.outer,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          controller.delete_file(
                            controller.files_ids[index],
                            index,
                            Files_Types.pdf,
                          );
                        },
                        child: const Icon(
                          Iconsax.trash,
                          color: Colors.red,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                if (Auth!.getString("user") == "active_student")
                  Positioned(
                    bottom: 10,
                    right: controller.download_circle == null ? 70 : 95,
                    child: GetBuilder<HomeController>(
                      id: 'saved_files',
                      init: HomeController(),
                      builder: (controller) {
                        return Container(
                          width: width / 8,
                          height: width / 8,
                          decoration: BoxDecoration(
                            color: Themes.colorScheme.onPrimaryContainer,
                            border: Border.all(
                              width: 3,
                              color:
                                  Themes.getColor(Colors.white, Colors.white),
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Themes.getColor(Colors.green, Colors.blue),
                                blurStyle: BlurStyle.outer,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: controller.is_added_to_saved_files[index]
                              ? added_to_saved_files
                              : add_to_saved_files,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
