import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Quizzes_Controllers/quiz_controller.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/add_quiz_screens/add_quiz_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/quiz_screens_doctor/quiz_screen_details.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final content = Container(
      width: width / 6,
      height: width / 7.5,
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
            blurRadius: Themes.isDarkMode() ? 2 : 5,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: InkWell(
        onTap: () => Get.to(() => const AddQuizScreen()),
        child: const Icon(
          size: 35,
          Iconsax.add_square,
          color: Colors.white,
        ),
      ),
    );

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
            GetBuilder<QuizController>(
                id: "quiz_deleted",
                builder: (controller) {
                  return Center(
                    child: controller.quizzes.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 50),
                              const Image(
                                image: AssetImage(
                                    'assets/images/quiz_not_found.png'),
                                width: 120,
                                height: 120,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No Quizzes Added Yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              Text(
                                'Add One!',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 20,
                                      color: Colors.redAccent,
                                    ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: GetBuilder<QuizController>(
                                id: 'quizzes',
                                builder: (controller_quiz) {
                                  return ListView.builder(
                                    itemCount: controller.quizzes.length,
                                    itemBuilder: (context, index) {
                                      var quiz = controller.quizzes[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 320,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 2,
                                                color: Themes.getColor(
                                                    Colors.white, Colors.black),
                                                blurStyle: BlurStyle.outer,
                                                spreadRadius: 1,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        blurRadius: 2,
                                                        color: Colors.black,
                                                        blurStyle:
                                                            BlurStyle.outer,
                                                        spreadRadius: 1,
                                                      )
                                                    ],
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 3,
                                                    ),
                                                    color: is_Dark!.getString(
                                                                'is_dark') ==
                                                            'true'
                                                        ? Themes.darkColorScheme
                                                            .primaryContainer
                                                            .withOpacity(.7)
                                                        : Colors.blue
                                                            .withOpacity(.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Subject : ${quiz['subject']}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Quiz Type : ${quiz['type']}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Questions : ${quiz['questions'].length}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Level : ${quiz['level']}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Time : ${quiz['time']} min',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: () => Get.to(
                                                    () => QuizDetailScreen(
                                                        quiz: quiz),
                                                  ),
                                                  child: Container(
                                                    width: width / 6,
                                                    height: width / 8,
                                                    decoration: BoxDecoration(
                                                      color: Themes.colorScheme
                                                          .onPrimaryContainer,
                                                      border: Border.all(
                                                        width: 3,
                                                        color: Themes.getColor(
                                                            Colors.white,
                                                            Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Themes.getColor(
                                                                  Colors.green,
                                                                  Colors.blue),
                                                          blurStyle:
                                                              BlurStyle.outer,
                                                          blurRadius: 5,
                                                          offset: const Offset(
                                                              0, 1),
                                                        )
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      size: 25,
                                                      Iconsax.arrow_right,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Positioned(
                                                bottom: 5,
                                                right: 90,
                                                child: InkWell(
                                                  onTap: () {
                                                    int id = controller
                                                        .quizzes_ids[index];
                                                    controller.remove_quiz(
                                                        context, id);
                                                    controller.update_timer(
                                                        id, index);
                                                  },
                                                  child: Container(
                                                    width: width / 6,
                                                    height: width / 8,
                                                    decoration: BoxDecoration(
                                                      color: Themes.colorScheme
                                                          .onPrimaryContainer,
                                                      border: Border.all(
                                                        width: 3,
                                                        color: Themes.getColor(
                                                            Colors.white,
                                                            Colors.white),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Themes.getColor(
                                                                  Colors.green,
                                                                  Colors.blue),
                                                          blurStyle:
                                                              BlurStyle.outer,
                                                          blurRadius: 5,
                                                          offset: const Offset(
                                                              0, 1),
                                                        )
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      size: 25,
                                                      Iconsax.trash,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                  );
                }),
            Positioned(
              right: 20,
              top: 15,
              child: content,
            ),
          ],
        );
      },
    );
  }
}
