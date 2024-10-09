// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/controllers/Dark_mode_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.path,
  });

  final void Function() onTap;
  final String leading;
  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final viewSubjectsIcon = Icon(
      Iconsax.arrow_right,
      size: width / 10,
      color: Colors.white,
    );

    return GetBuilder<DarkModeController>(
      init: DarkModeController(),
      builder: (darkController) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width / 45,
            vertical: width / 45 / 2,
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Colors.green
                    : Colors.blue,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: is_Dark!.getString('is_dark') == 'true'
                    ? [
                        const Color(0xff83D5C1),
                        const Color(0xff83D5C1).withGreen(200),
                        const Color(0xff606871),
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
            width: width / 1.1,
            height: height / 15,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year number :
                Row(
                  children: [
                    Text(
                      leading,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width / 12,
                          ),
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width / 12,
                          ),
                    ),
                  ],
                ),
                // image for the year :
                Padding(
                  padding: EdgeInsets.only(
                    right: width / 2.5,
                  ),
                  child: Image(
                    width: width / 2.4,
                    height: height / 5,
                    image: AssetImage(path),
                  ),
                ),
                // Button To go to subjects screen :
                Padding(
                  padding: EdgeInsets.only(right: width / 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: width / 3,
                        height: width / 6,
                        decoration: BoxDecoration(
                          color: Themes.colorScheme.onPrimaryContainer
                              .withOpacity(.8),
                          border: Border.all(
                            width: 3,
                            color: is_Dark!.getString('is_dark') == 'true'
                                ? Colors.green
                                : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: is_Dark!.getString('is_dark') == 'true'
                                  ? Colors.white
                                  : Colors.black,
                              blurStyle: BlurStyle.outer,
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Go',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: width / 12,
                                    color: Colors.white,
                                  ),
                            ),
                            SizedBox(width: width / 20),
                            GetBuilder<HomeController>(
                              id: 'viewSubject',
                              init: HomeController(),
                              builder: (h_controller) {
                                return InkWell(
                                  onTap: onTap,
                                  child: h_controller.circleViewSubject ??
                                      viewSubjectsIcon,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
