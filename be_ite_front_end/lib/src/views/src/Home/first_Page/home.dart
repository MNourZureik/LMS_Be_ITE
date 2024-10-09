// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/views/src/Home/first_Page/HomeCard.dart';
import 'package:public_testing_app/src/views/src/Home/first_Page/Recent_Files/Recent_Files.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final animate1 = <Effect>[const SlideEffect(curve: Curves.linear)];
    final animate2 = <Effect>[
      const SlideEffect(
        begin: Offset(0, 0.5),
        end: Offset(0, 0),
        curve: Curves.linear,
      )
    ];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    List<Widget> content = [];
    return GetBuilder<HomeController>(
      id: 'seeAll',
      init: HomeController(),
      builder: (h_controller) {
        if (appData!.getBool('isSeeAll') == false) {
          content = [
            const SizedBox(height: 10),
            SizedBox(
              width: width,
              height: width / 1.2,
              child: ListView.builder(
                itemCount: 3,
                controller: h_controller.scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return HomeCard(
                    path: h_controller.photo_paths_of_years[index],
                    leading: h_controller.numbers_of_years[index],
                    title: h_controller.years[index],
                    onTap: () {
                      h_controller.viewSubjectsOfTheYear(index + 1);
                    },
                  );
                },
              ),
            )
          ];
        } else {
          content = [];
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...content.animate().fade(
                  curve: Curves.easeInOut,
                  duration: Durations.extralong1,
                ),
            Expanded(
              child: RecentFiles(
                onTap: () {
                  if (appData!.getBool('isSeeAll') == false) {
                    appData!.setBool('isSeeAll', true);
                  } else {
                    appData!.setBool('isSeeAll', false);
                  }
                  controller.update(['seeAll']);
                },
              ).animate(
                effects: appData!.getBool('isSeeAll')! ? animate2 : animate1,
              ),
            )
          ],
        );
      },
    );
  }
}
