// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/third_Page/subjectTypeCard.dart';


class Subjecttype extends StatelessWidget {
  const Subjecttype(
      {super.key,
      required this.subjectName,
      required this.index,
      required this.teacher,
      required this.doctors,
      required this.year});

  final String teacher;
  final List<dynamic> doctors;
  final String subjectName;
  final int index;
  final int year;

  @override
  Widget build(BuildContext context) {
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);
    final Home_Controller = Get.put(HomeController());

    List<Widget> thP = [
      SubjectTypeCard(
        year: year,
        subject_name: subjectName,
        Type: 'Theoritical',
        Doctors_Names: doctors,
        path: 'assets/images/design.png',
      ),
    ];

    if (Home_Controller.isHasPractical(subjectName)) {
      thP = [
        SubjectTypeCard(
          year: year,
          subject_name: subjectName,
          Type: 'Theoritical',
          Doctors_Names: doctors,
          path: 'assets/images/design.png',
        ),
        const SizedBox(height: 20),
        SubjectTypeCard(
          year: year,
          subject_name: subjectName,
          Type: 'Practical',
          Doctors_Names: teacher,
          path: 'assets/images/responsibility.png',
        ),
      ];
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: is_Dark!.getString('is_dark') == 'true'
            ? Themes.darkColorScheme.background.withOpacity(.9)
            : Colors.white,
        // AppBar decoration:
        appBar: AppBar(
          backgroundColor: is_Dark!.getString('is_dark') == 'true'
              ? Themes.darkColorScheme.background
              : Themes.colorScheme.primaryContainer,
          title: year == 1
              ? MarqueeText(
                  alwaysScroll: true,
                  speed: 15,
                  text: TextSpan(
                    text: '1. ${Home_Controller.years[0]} / $subjectName :',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: width / 18,
                        color: is_Dark!.getString('is_dark') == 'true'
                            ? Themes.darkColorScheme.primary
                            : Themes.colorScheme.primary),
                  ),
                )
              : year == 2
                  ? MarqueeText(
                      alwaysScroll: true,
                      speed: 15,
                      text: TextSpan(
                        text: '2. ${Home_Controller.years[1]} / $subjectName :',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width / 18,
                            color: is_Dark!.getString('is_dark') == 'true'
                                ? Themes.darkColorScheme.primary
                                : Themes.colorScheme.primary),
                      ),
                    )
                  : MarqueeText(
                      alwaysScroll: true,
                      speed: 15,
                      text: TextSpan(
                        text: '3. ${Home_Controller.years[2]} / $subjectName :',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width / 18,
                            color: is_Dark!.getString('is_dark') == 'true'
                                ? Themes.darkColorScheme.primary
                                : Themes.colorScheme.primary),
                      ),
                    ),
        ),
        body: Column(
          children: [
            Container(
              width: width,
              height: width / 7,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: is_Dark!.getString('is_dark') == 'true'
                        ? Colors.green.withGreen(255)
                        : Colors.blue.withBlue(255),
                    blurStyle: BlurStyle.outer,
                    offset: const Offset(0, 1),
                    blurRadius: 7,
                  )
                ],
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Themes.darkColorScheme.background
                    : Themes.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 10),
                child: Text(
                  '$subjectName :',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: width / 15,
                      color: is_Dark!.getString('is_dark') == 'true'
                          ? Themes.darkColorScheme.primary
                          : Themes.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...thP,
          ],
        ),
      ),
    );
  }
}
