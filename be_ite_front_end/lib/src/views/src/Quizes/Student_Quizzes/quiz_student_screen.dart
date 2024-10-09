import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Quizzes_Controllers/quiz_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Quizes/Student_Quizzes/quiz_solving_screen.dart';

import 'quiz_result_screen.dart';

class QuizStudentScreen extends StatelessWidget {
  const QuizStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<QuizController>(
      init: QuizController(),
      builder: (controller) {
        return Stack(
          children: [
            Positioned(
              top: 20,
              left: 10,
              child: Text(
                'Quizzes :',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 30,
                    ),
              ),
            ),
            Center(
              child: controller.quizzes.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Image(
                          image: AssetImage('assets/images/quiz_not_found.png'),
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No Quizzes Added Yet',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 20,
                                  ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: ListView.builder(
                        itemCount: controller.quizzes.length,
                        itemBuilder: (context, index) {
                          var quiz = controller.quizzes[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 300,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Themes.getColor(
                                      Colors.green, Colors.blue),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                  colors: Themes.isDarkMode()
                                      ? [
                                          const Color(0xff606871),
                                          const Color(0xff83D5C1)
                                              .withGreen(200),
                                          const Color(0xff83D5C1),
                                        ]
                                      : [
                                          const Color(0xff64ACFF),
                                          const Color(0xff85AAD5),
                                          const Color(0xff606871),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    left: 10,
                                    child: Container(
                                      height: 200,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        color: is_Dark!.getString('is_dark') ==
                                                'true'
                                            ? Themes.darkColorScheme
                                                .primaryContainer
                                                .withOpacity(.7)
                                            : Colors.blue.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Subject : ${quiz['subject']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Quiz Type : ${quiz['type']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Questions : ${quiz['questions'].length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Level : ${quiz['level']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Time : ${quiz['time']} min',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: controller
                                                  .completed_quizzes[index]
                                              ? Colors.green
                                              : Colors.red,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child:
                                            controller.completed_quizzes[index]
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )
                                                : const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        if (controller
                                                .completed_quizzes[index] ==
                                            true) {
                                          Get.to(
                                            () => QuizResultScreen(
                                              studentAnswers:
                                                  controller.selected_answers,
                                              quiz: quiz,
                                            ),
                                          );
                                        } else {
                                          Get.to(
                                            () => QuizStudentDetailScreen(
                                              quiz: quiz,
                                              quizIndex: index,
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: width / 3.8,
                                        height: width / 8,
                                        decoration: BoxDecoration(
                                          color: Themes
                                              .colorScheme.onPrimaryContainer,
                                          border: Border.all(
                                            width: 3,
                                            color: Themes.getColor(
                                                Colors.white, Colors.white),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Themes.getColor(
                                                  Colors.green, Colors.blue),
                                              blurStyle: BlurStyle.outer,
                                              blurRadius: 5,
                                              offset: const Offset(0, 1),
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              controller
                                                      .completed_quizzes[index]
                                                  ? 'Open'
                                                  : 'Solve',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              size: 25,
                                              Iconsax.arrow_right,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
