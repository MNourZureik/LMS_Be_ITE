import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/OtherUsers_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/MySubject/My_Subjects_Other_Users/OtherUsersSubjectsCard.dart';

class Otheruserssubjects extends StatelessWidget {
  const Otheruserssubjects({super.key});

  @override
  Widget build(BuildContext context) {
    final OtherusersSubjectsController dr_controller =
        Get.put(OtherusersSubjectsController());
    return Column(
      children: [
        // Text for clearify section :
        Container(
          width: Themes.getWidth(context),
          height: 70,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Themes.getColor(
                    Colors.green.withGreen(255), Colors.blue.withBlue(255)),
                blurStyle: BlurStyle.outer,
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
            color: Themes.getColor(Themes.darkColorScheme.background,
                Themes.colorScheme.primaryContainer),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Center(
            child: ListTile(
              title: Text(
                "Your Subjects :",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 25,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: GetBuilder<OtherusersSubjectsController>(
            id: 'other_user_subjects',
            init: OtherusersSubjectsController(),
            builder: (st_sub_controller) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                  ),
                  itemCount:
                      st_sub_controller.other_user_subjects_information.length,
                  itemBuilder: (ctx, index) {
                    return OtherUserSubjectsCard(index: index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
