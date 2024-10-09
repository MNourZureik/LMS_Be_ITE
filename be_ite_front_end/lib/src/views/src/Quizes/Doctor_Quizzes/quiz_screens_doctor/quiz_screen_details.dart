import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class QuizDetailScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;

  const QuizDetailScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
      appBar: AppBar(
        title: const Text('Quiz Details'),
        backgroundColor: Themes.getColor(Themes.darkColorScheme.background,
            Themes.colorScheme.primaryContainer),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: int.parse(quiz['num_question']),
          itemBuilder: (context, index) {
            var questions = quiz['questions'][index];
            return Column(
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Themes.getColor(
                        Themes.darkColorScheme.primaryContainer.withOpacity(.7),
                        Colors.blue.withOpacity(.5)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border.all(
                      color: Themes.getColor(Themes.darkColorScheme.primary,
                          Themes.colorScheme.primary),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${questions["qeustion"]}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          questions["answers"].length,
                          (i) {
                            return Text(
                              "${i + 1}. ${questions["answers"][i]}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 16,
                                    color: questions["answers"][i] ==
                                            questions["correct_answer"]
                                        ? Colors.green
                                        : Themes.getColor(
                                            Colors.white,
                                            Colors.black,
                                          ),
                                  ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
