// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class Subjectcard extends StatelessWidget {
  const Subjectcard({
    super.key,
    required this.subject,
    required this.index,
    required this.subject_id,
    required this.year,
  });

  final String subject;
  final int index;
  final int subject_id;
  final int year;

  @override
  Widget build(BuildContext context) {
    final h_controller = Get.put(HomeController());
    // add to my subjects icon :
    final addSubject = InkWell(
      onTap: () => h_controller.isHasPractical(subject)
          ? h_controller.dialog_for_adding_subject_to_MySubjects(
              context, subject_id, index)
          : h_controller.addToMySubjects(subject_id, index),
      child: const Icon(
        size: 30,
        Iconsax.add_square,
        color: Colors.white,
      ),
    );
    // remove from my subjects :
    final removeSubject = InkWell(
      onTap: () {
        h_controller.removeFromMySubjects(subject_id, index);
      },
      child: const Icon(
        size: 30,
        Iconsax.trash,
        color: Colors.redAccent,
      ),
    );
    // Go To Theoritical or practical Button :
    final go = InkWell(
      onTap: () {
        h_controller.viewSubjectTypes(index, subject, year);
      },
      child: const Icon(
        size: 30,
        Iconsax.arrow_right,
        color: Colors.white,
      ),
    );
    // screen width and height :
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);
    // page :
    return Container(
      decoration: BoxDecoration(
        color: is_Dark!.getString('is_dark') == 'true'
            ? Themes.darkColorScheme.primaryContainer.withOpacity(.7)
            : Colors.blue.withOpacity(.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(
          color: is_Dark!.getString('is_dark') == 'true'
              ? Themes.darkColorScheme.primary
              : Themes.colorScheme.primary,
          width: 3,
        ),
      ),
      width: width,
      height: height / 12,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: ListTile(
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${index + 1}. ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: is_Dark!.getString('is_dark') == 'true'
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                  Text(
                    subject,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: is_Dark!.getString('is_dark') == 'true'
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: width / 1.7,
            top: 10,
            child: Row(
              children: [
                Container(
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
                    width: width / 7,
                    height: height / 19,
                    //! update every subject :
                    child: GetBuilder<HomeController>(
                      id: 'add_reomve_subject',
                      init: HomeController(),
                      builder: (h_controller) {
                        return h_controller.isAdded_theoritical[index] == false
                            ? addSubject
                            : removeSubject;
                      },
                    )),
                const SizedBox(width: 10),
                Container(
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
                    width: width / 7,
                    height: height / 19,
                    child: GetBuilder<HomeController>(
                      id: 'GO',
                      init: HomeController(),
                      builder: (h_controller) {
                        return go;
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
