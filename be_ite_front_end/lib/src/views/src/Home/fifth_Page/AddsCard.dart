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

class AddsCard extends StatelessWidget {
  const AddsCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);
    StudentSubjectsController? student_controller;
    OtherusersSubjectsController? other_controller;
    if (Auth!.getString("user") != "active_student") {
      other_controller = Get.find<OtherusersSubjectsController>();
    }

    if (Auth!.getString("user") == "active_student") {
      student_controller = Get.put(StudentSubjectsController());
    }
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GetBuilder<HomeController>(
            id: 'is_col[$index]',
            builder: (xt) {
              return Container(
                decoration: BoxDecoration(
                  color: Themes.getColor(
                    Themes.darkColorScheme.primaryContainer.withOpacity(.7),
                    Colors.blue.withOpacity(.5),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 1,
                    )
                  ],
                ),
                width: width,
                height: controller.is_colapse[index] ? height / 4 : height / 11,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        "${controller.notifications_ids[index]["title"]}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: Text(
                        "${controller.notifications_ids[index]["date"]}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 10,
                      child: Text(
                        "${controller.notifications_ids[index]["time"]}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 10,
                      child: SizedBox(
                        height: height / 4,
                        width: 200,
                        child: SingleChildScrollView(
                          child: Text(
                            "${controller.notifications_ids[index]["body"]}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 18,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: controller.download_circle == null
                                ? width / 8
                                : width / 6,
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
                                  color: Themes.getColor(
                                      Colors.green, Colors.blue),
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                )
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                xt.is_colapse[index] = !xt.is_colapse[index];
                                xt.update(['is_col[$index]']);
                              },
                              child: Icon(
                                !xt.is_colapse[index]
                                    ? Iconsax.arrow_down
                                    : Iconsax.arrow_up_3,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (Auth!.getString("user") != "active_student")
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: controller.download_circle == null
                                  ? width / 8
                                  : width / 6,
                              height: width / 8,
                              decoration: BoxDecoration(
                                color: Themes.colorScheme.onPrimaryContainer,
                                border: Border.all(
                                  width: 3,
                                  color: Themes.getColor(
                                      Colors.white, Colors.white),
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Themes.getColor(
                                        Colors.green, Colors.blue),
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.delete_notification(
                                    controller.notifications_ids[index]["id"],
                                  );
                                  controller.notifications_ids.removeAt(index);
                                },
                                child: const Icon(
                                  Iconsax.trash,
                                  color: Colors.red,
                                  size: 26,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
