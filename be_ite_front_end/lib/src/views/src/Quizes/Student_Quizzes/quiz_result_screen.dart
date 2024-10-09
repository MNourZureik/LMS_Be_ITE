import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Quizzes_Controllers/quiz_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class QuizResultScreen extends StatelessWidget {
  final Map<int, int?> studentAnswers;
  final Map<String, dynamic> quiz;

  const QuizResultScreen(
      {super.key, required this.studentAnswers, required this.quiz});

  @override
  Widget build(BuildContext context) {
    int correctAnswersCount = 0;
    List<Widget> resultWidgets = [];
    final QuizController controller = Get.find();

    for (int i = 0; i < int.parse(quiz['num_question']); i++) {
      final questions = quiz['questions'][i];
      final correctAnswer = questions['correct_answer'];
      String studentAnswer = '';

      if (Get.previousRoute == "/QuizStudentDetailScreen") {
        studentAnswer = controller.student_answers[i];
      } else {
        studentAnswer = quiz["student_answers"][i];
      }

      String answer = '';
      if (studentAnswer == '') {
        answer = "Not Answering";
      } else {
        answer = studentAnswer;
      }

      bool isCorrect = studentAnswer == correctAnswer;
      if (isCorrect) {
        correctAnswersCount++;
      }
      resultWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Themes.getColor(
                Themes.darkColorScheme.onPrimary.withOpacity(.3),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          Themes.getColor(Colors.white, Colors.black38),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "${i + 1}",
                            style: Get.textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Question : ${questions['qeustion']}',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Student Answer: $answer',
                    style: Get.textTheme.titleLarge!.copyWith(
                      fontSize: 15,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    'Correct Answer: ${questions['correct_answer']}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final degree = correctAnswersCount / int.parse(quiz['num_question']) * 100;

    return WillPopScope(
      onWillPop: () async {
        controller.quizzes = [];
        controller.completed_quizzes = [];
        controller.quizzes_ids = [];
        controller.get_student_quizes();
        return true;
      },
      child: Scaffold(
        backgroundColor: Themes.getColor(
            Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
        appBar: AppBar(
          backgroundColor: Themes.getColor(Themes.darkColorScheme.background,
              Themes.colorScheme.primaryContainer),
          title: Text(
            'Quiz Result : ',
            style: Get.textTheme.titleLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Text(
                textAlign: TextAlign.center,
                'Your degree is ${degree.toStringAsFixed(0)} of 100%',
                style: Get.textTheme.titleLarge!.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Text(
                textAlign: TextAlign.center,
                'You have answered $correctAnswersCount questions right out of ${quiz['questions'].length}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView(
                  children: resultWidgets,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
