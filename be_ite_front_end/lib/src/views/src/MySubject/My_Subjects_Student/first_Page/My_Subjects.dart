import 'package:flutter/material.dart';
import 'package:public_testing_app/main.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/Student_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/MySubject/My_Subjects_Student/first_Page/My_Subjects_Card.dart';

class MySubjects extends StatelessWidget {
  // Contructers :
  const MySubjects({super.key});

  @override
  Widget build(BuildContext context) {
    final student_controller = Get.put(StudentSubjectsController());
    return Column(
      children: [
        // Text for clearify section :
        Container(
          width: Themes.getWidth(context),
          height: 70,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Colors.green.withGreen(255)
                    : Colors.blue.withBlue(255),
                blurStyle: BlurStyle.outer,
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
            color: is_Dark!.getString('is_dark') == 'true'
                ? Themes.darkColorScheme.background
                : Themes.colorScheme.primaryContainer,
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
          child: GetBuilder<StudentSubjectsController>(
            id: 'subjects',
            init: StudentSubjectsController(),
            builder: (st_sub_controller) {
              return st_sub_controller.student_subjects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Image(
                            width: 100,
                            height: 100,
                            image: AssetImage('assets/images/error-404.png'),
                          ),
                          Text(
                            'No Subjects added yet',
                            style: Get.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: st_sub_controller.student_subjects.length,
                        itemBuilder: (ctx, index) {
                          return MySubjectsCard(
                            index: index,
                          );
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
