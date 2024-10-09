import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/src/controllers/Quizzes_Controllers/quiz_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/Introduction/IntroductionScreen.dart';

class MultipleAnswersScreen extends StatelessWidget {
  final int numQuestions;
  const MultipleAnswersScreen({super.key, required this.numQuestions});

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find();
    final width = Themes.getWidth(context);
    final hieght = Themes.getHeight(context);
    final List<Widget> MA = [];

    for (int i = 0; i < quizController.numQuestion; i++) {
      MA.add(
        GetBuilder<QuizController>(
          id: 'update_num_question',
          init: QuizController(),
          builder: (qquizController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 5),
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
                child: GetBuilder<QuizController>(
                  id: 'quiz',
                  init: QuizController(),
                  builder: (qq) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Themes.getColor(
                                Colors.white,
                                Colors.blue,
                              ),
                            ),
                          ),
                          child: Form(
                            key: quizController
                                .form_key_for_multible_question[i],
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Question";
                                }
                                if (int.tryParse(value) != null ||
                                    double.tryParse(value) != null) {
                                  return "Enter a valid Question";
                                }
                              },
                              onSaved: (newValue) {
                                quizController.questionControllers[i].text =
                                    newValue!;
                              },
                              decoration: InputDecoration(
                                hintText: 'Question',
                                hintStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(
                            quizController.answerFieldCounts[i],
                            (j) => Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        width: 2,
                                        color: Themes.getColor(
                                          Colors.white,
                                          Colors.blue,
                                        ),
                                      ),
                                    ),
                                    child: Form(
                                      key: quizController
                                          .form_key_for_multible_answers[i][j],
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please Enter Answer";
                                          }
                                        },
                                        onSaved: (value) {
                                          qq.answerControllers[i][j].text =
                                              value!;
                                        },
                                        controller: qq.answerControllers[i][j],
                                        decoration: InputDecoration(
                                          hintText: 'Enter answer ${j + 1}',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    qq.correctAnswers[i] == j
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: qq.correctAnswers[i] == j
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    qq.setCorrectAnswer(i, j);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if (quizController.answerFieldCounts[i] < 5)
                              IconButton(
                                onPressed: () {
                                  quizController.addAnswerField(i);
                                },
                                icon: Icon(
                                  Iconsax.add_square,
                                  size: 35,
                                  color: Themes.getColor(
                                      Colors.white, Colors.blue),
                                  shadows: const [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 2,
                                      spreadRadius: 5,
                                      offset: Offset(0, 0.5),
                                    )
                                  ],
                                ),
                              ),
                            if (quizController.answerFieldCounts[i] > 2)
                              IconButton(
                                onPressed: () {
                                  quizController.removeAnswerField(i);
                                },
                                icon: Icon(
                                  Iconsax.minus_square,
                                  size: 35,
                                  color: Themes.getColor(
                                      Colors.white, Colors.blue),
                                  shadows: const [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 2,
                                      spreadRadius: 5,
                                      offset: Offset(0, 0.5),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
      appBar: AppBar(
        title: const Text('Multiple Answers Questions'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            child: Row(
              children: [
                Text(
                  'Complete This Form :',
                  style: Get.textTheme.titleLarge,
                ),
                const SizedBox(
                  width: 120,
                ),
                GetBuilder<QuizController>(
                    id: 'publish',
                    builder: (controller) {
                      return InkWell(
                        onTap: () {
                          quizController.publishQuiz_MultiAnswers(numQuestions);
                        },
                        child: Container(
                          padding:  EdgeInsets.symmetric(
                              horizontal:quizController.circle==null? 10:15, vertical: 10),
                          width: width / 6.5,
                          height: width / 7,
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
                                blurRadius: 5,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: controller.circle ??
                              const Icon(
                                size: 35,
                                Iconsax.arrow_up_1,
                                color: Colors.white,
                              ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [...MA],
              ),
            ),
          )
        ],
      ),
    );
  }
}
