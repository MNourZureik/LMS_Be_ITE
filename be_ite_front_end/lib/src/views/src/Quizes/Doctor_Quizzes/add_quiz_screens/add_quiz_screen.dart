import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/src/controllers/Quizzes_Controllers/quiz_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/widgets/TextFormField.dart';

class AddQuizScreen extends StatelessWidget {
  const AddQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.put(QuizController());
    final width = Themes.getWidth(context);
    final hieght = Themes.getHeight(context);

    return Scaffold(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
      appBar: AppBar(
        title: const Text('Add Quiz'),
        backgroundColor: Themes.getColor(Themes.darkColorScheme.background,
            Themes.colorScheme.primaryContainer),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: width,
          height: width + 300,
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
              width: 7,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                // choose the subject :
                Positioned(
                  top: 15,
                  child: Text(
                    'Choose the subject :',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18),
                  ),
                ),
                Positioned(
                  right: 5,
                  child: GetBuilder<QuizController>(
                    init: QuizController(),
                    builder: (controller) {
                      return InkWell(
                        onTap: () {
                          controller
                              .dialog_for_choosing_subject_from_MySubjects(
                                  context);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: width / 2.8,
                            height: width / 8,
                            decoration: BoxDecoration(
                              color: Themes.colorScheme.onPrimaryContainer,
                              border: Border.all(
                                width: 3,
                                color: Colors.white,
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
                            child: Row(
                              children: [
                                const Icon(
                                  Iconsax.sidebar_top,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                GetBuilder<QuizController>(
                                    id: 'choose_subject',
                                    builder: (add_controller) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.selectedSubject,
                                            style: Get.textTheme.titleLarge!
                                                .copyWith(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            controller.Selected_Type_Subject,
                                            style: Get.textTheme.titleLarge!
                                                .copyWith(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            )),
                      );
                    },
                  ),
                ),
                // Hint for enter field :
                Positioned(
                  top: 80,
                  child: Text(
                    'Enter the number of Questions at',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18),
                  ),
                ),
                // complement of the hint :
                Positioned(
                  top: 110,
                  child: Text(
                    'least 3 and at most 15:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18),
                  ),
                ),
                // field :
                Positioned(
                  top: 150,
                  left: 0,
                  child: SizedBox(
                    width: width - 80,
                    height: 85,
                    child: Form(
                      key: controller.form_key,
                      child: MyTextFormField(
                        initValue: '3',
                        keyboard: TextInputType.number,
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "number required";
                          }
                          if (int.tryParse(value) == null ||
                              double.tryParse(value) == null) {
                            return "Invalid Input";
                          }
                          int num = int.parse(value);
                          if (num < 3 || num > 15) {
                            return "Invalid number";
                          }
                        },
                        save: (value) {
                          controller.numQuestion = int.parse(value!);
                        },
                        label: 'Enter number here ...',
                        prefixIcon:
                            const Icon(Icons.format_list_numbered_rtl_rounded),
                      ),
                    ),
                  ),
                ),
                // difficulty :
                Positioned(
                  top: 240,
                  child: Row(
                    children: [
                      Text(
                        'Select the level of difficulty :',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 15),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: width / 3.5,
                        height: width / 8,
                        decoration: BoxDecoration(
                          color: Themes.colorScheme.onPrimaryContainer,
                          border: Border.all(
                            width: 3,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Themes.getColor(Colors.green, Colors.blue),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: GetBuilder<QuizController>(
                          init: QuizController(),
                          builder: (controller) {
                            return DropdownButton<String>(
                              iconEnabledColor: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                              underline: Container(
                                color: Colors.white,
                              ),
                              isDense: false,
                              dropdownColor:
                                  Themes.colorScheme.onPrimaryContainer,
                              value: controller.selectedLevel,
                              items: controller.levels.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  controller.setSelectedLevel(newValue);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //Set Timer :
                Positioned(
                  top: 330,
                  child: Text(
                    "Set Timer from 3 to 15 minutes :",
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 16),
                  ),
                ),
                Positioned(
                  top: 360,
                  child: SizedBox(
                    width: width - 80,
                    height: 85,
                    child: Form(
                      key: controller.timer_form_key,
                      child: MyTextFormField(
                        keyboard: TextInputType.number,
                        initValue: "3",
                        label: 'Enter Time here ...',
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "number required";
                          }
                          if (int.tryParse(value) == null ||
                              double.tryParse(value) == null) {
                            return "Invalid Input";
                          }
                          int num = int.parse(value);
                          if (num < 3 || num > 15) {
                            return "Invalid number";
                          }
                        },
                        save: (value) {
                          controller.setSelectedTimer(int.parse(value!));
                        },
                        prefixIcon:
                            const Icon(Icons.format_list_numbered_rtl_rounded),
                      ),
                    ),
                  ),
                ),
                // types of questions :
                Positioned(
                  top: 450,
                  left: 0,
                  child: Text(
                    'Enter the Types of Questions :',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 16),
                  ),
                ),
                Positioned(
                  top: 480,
                  right: 100,
                  child: SizedBox(
                    width: 250,
                    height: 150,
                    child: GetBuilder<QuizController>(
                      init: QuizController(),
                      builder: (controller) {
                        return Column(
                          children: [
                            RadioListTile<String>(
                              title: const Text('True OR False'),
                              value: 'true_or_false',
                              groupValue: controller.selectedQuestionType,
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.setSelectedQuestionType(value);
                                }
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('Multiple Answers'),
                              value: 'multiple_answers',
                              groupValue: controller.selectedQuestionType,
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.setSelectedQuestionType(value);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // Next page button :
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: width / 4,
                    height: width / 8,
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
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        controller.onSave();
                        controller.init_num_question(controller.numQuestion);
                      },
                      child: Center(
                        child: Text(
                          'Next',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
