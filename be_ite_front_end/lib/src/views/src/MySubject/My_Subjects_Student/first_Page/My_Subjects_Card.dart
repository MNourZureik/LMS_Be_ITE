import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Dark_mode_Controller.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/Student_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/MySubject/My_Subjects_Student/second_Page/My_Subject_Types.dart';

class MySubjectsCard extends StatelessWidget {
  const MySubjectsCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final student_subject_controller = Get.put(StudentSubjectsController());
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);

    String name = student_subject_controller.student_subjects[index]["name"];
    String type = student_subject_controller.student_subjects[index]["type"];
    String year = student_subject_controller.student_subjects[index]["year"];
    Widget remove_student_subject = InkWell(
      onTap: () {
        int? subject_pr_id;
        int? subject_th_id;
        if (type == "theoretical and practical") {
          subject_th_id =
              student_subject_controller.student_subjects[index]["id_theo"];
          subject_pr_id =
              student_subject_controller.student_subjects[index]["id_pra"];
          student_subject_controller.dialog_for_adding_subject_to_MySubjects(
              context, subject_th_id!, subject_pr_id!, index);
        } else {
          subject_th_id =
              student_subject_controller.student_subjects[index]["id_theo"];
          student_subject_controller.removeFromMySubjects(subject_th_id!);
          student_subject_controller.student_subjects
              .remove(student_subject_controller.student_subjects[index]);

          student_subject_controller.update(["subjects"]);
        }
      },
      child: const Icon(
        Iconsax.trash,
        size: 30,
        color: Colors.redAccent,
      ),
    );

    return GetBuilder<DarkModeController>(
      init: DarkModeController(),
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width - 30,
              height: width - 190,
              decoration: BoxDecoration(
                border: Border.all(
                  color: is_Dark!.getString('is_dark') == 'true'
                      ? Themes.darkColorScheme.primary
                      : Themes.colorScheme.primary,
                  width: 3,
                ),
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Themes.darkColorScheme.primaryContainer.withOpacity(.7)
                    : Colors.blue.withOpacity(.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 1,
                          )
                        ],
                        color: is_Dark!.getString('is_dark') == 'true'
                            ? Themes.darkColorScheme.primaryContainer
                                .withOpacity(.7)
                            : Colors.blue.withOpacity(.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              textAlign: TextAlign.center,
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "PoetsenOne",
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              textAlign: TextAlign.center,
                              type,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "SpaceGrotesk",
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              textAlign: TextAlign.center,
                              year,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "SpaceGrotesk",
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
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
                      width: width / 7 - 5,
                      height: height / 19,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => MySubjectstypes(index: index));
                        },
                        child: const Icon(
                          Iconsax.arrow_right,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // here
                  Positioned(
                    right: 75,
                    bottom: 10,
                    child: Container(
                      width: width / 7 - 5,
                      height: height / 19,
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
                      child: remove_student_subject,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
