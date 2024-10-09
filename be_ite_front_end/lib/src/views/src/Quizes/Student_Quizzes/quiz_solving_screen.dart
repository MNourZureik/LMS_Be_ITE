import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Quizzes_Controllers/quiz_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class QuizStudentDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? quiz;
  final int? quizIndex; // جديد: الفهرس لتحديد الاختبار

  const QuizStudentDetailScreen(
      {super.key, @required this.quiz, @required this.quizIndex});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final QuizController controller = Get.find();
    controller.completed_quizzes[quizIndex!] = true;
    final time = int.parse(controller.quizzes[quizIndex!]["time"]);
    controller.startTimer(time * 60, quiz!);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Themes.getColor(
            Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Themes.getColor(Themes.darkColorScheme.background,
              Themes.colorScheme.primaryContainer),
          title: Text(
            'Solving Quiz :',
            style: Get.textTheme.titleLarge,
          ),
        ),
        body: GetBuilder<QuizController>(
          init: QuizController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GetX<QuizController>(builder: (context) {
                              return Text(
                                "Timer : ${controller.time}",
                                style: Get.textTheme.titleLarge,
                              );
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: width / 3.8,
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
                                    blurRadius: 5,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.submitAnswers(quiz!, quizIndex!);
                                },
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: Get.textTheme.titleLarge!.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: ListView.builder(
                      itemCount: int.parse(quiz!['num_question']),
                      itemBuilder: (context, index) {
                        var question = quiz!['questions'][index];
                        var answers = question['answers'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Themes.getColor(
                                Themes.darkColorScheme.onPrimary
                                    .withOpacity(.3),
                                Themes.colorScheme.primaryContainer,
                              ),
                              border: Border.all(
                                color: Themes.getColor(
                                  Themes.darkColorScheme.primary,
                                  Themes.colorScheme.primary,
                                ),
                                width: 5,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Question: ${question['qeustion']}',
                                  style: Get.textTheme.titleLarge!
                                      .copyWith(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    answers.length,
                                    (i) {
                                      return RadioListTile(
                                        title: Text(answers[i]),
                                        value: i,
                                        groupValue:
                                            controller.selected_answers[index],
                                        onChanged: (value) {
                                          controller.updateSelectedAnswer(
                                              index, value);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
