import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/second_Page/SubjectCard.dart';



class Subjects extends StatelessWidget {
  // Contructers :
  Subjects({super.key});
  Subjects.subject({
    super.key,
    required this.subjects,
    required this.id,
    required this.years,
    required this.Subjects_ids,
  });

  // Defining Data for page :
  List<String> subjects = [];
  int id = 1;
  List<String> years = [];
  List<int> Subjects_ids = [];

  // animate subjects cards :
  final animate1 = <Effect>[
    const FadeEffect(
      delay: Duration(milliseconds: 300),
    ),
    const SlideEffect(
        begin: Offset(0, 0.5),
        end: Offset(0, 0),
        curve: Curves.linearToEaseOut,
        duration: Duration(milliseconds: 300))
  ];
  final animate2 = <Effect>[
    const FadeEffect(delay: Duration(milliseconds: 300))
  ];

  // starting the page :
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
          title: id == 1
              ? Text(
                  '1. ${years[0]} :',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: width / 15,
                      color: is_Dark!.getString('is_dark') == 'true'
                          ? Themes.darkColorScheme.primary
                          : Themes.colorScheme.primary),
                )
              : id == 2
                  ? Text(
                      '2. ${years[1]} :',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: width / 15,
                          color: is_Dark!.getString('is_dark') == 'true'
                              ? Themes.darkColorScheme.primary
                              : Themes.colorScheme.primary),
                    )
                  : Text(
                      '3. ${years[2]} :',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: width / 15,
                          color: is_Dark!.getString('is_dark') == 'true'
                              ? Themes.darkColorScheme.primary
                              : Themes.colorScheme.primary),
                    ),
        ),
        body: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // curved Container for Welcoming :
              Container(
                width: width,
                height: width / 4,
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
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text(
                        'Welcome , Our Engineer',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: width / 13,
                            ),
                      ).animate(effects: animate2),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Subjects KeyWord :
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Subjects :',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: width / 15),
                ),
              ).animate(effects: animate1),
              const SizedBox(height: 10),
              // Listing Subjects From Back :
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Subjectcard(
                            year: id,
                            subject: subjects[index],
                            index: index,
                            subject_id: Subjects_ids[index],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ).animate(effects: animate1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
