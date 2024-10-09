// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Dark_mode_Controller.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class SubjectTypeCard extends StatelessWidget {
  SubjectTypeCard({
    super.key,
    required this.Doctors_Names,
    required this.Type,
    required this.path,
    required this.subject_name,
    required this.year,
    this.index,
  });
  final dynamic Doctors_Names;
  final String Type;
  final String path;
  final String subject_name;
  final int year;
  int? index;

  @override
  Widget build(BuildContext context) {
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);

    String doctors_names = '';
    if (Type == "Theoritical") {
      for (int i = 0; i < Doctors_Names.length; i++) {
        if (Doctors_Names.length != 1) {
          doctors_names = '$doctors_names , ' + Doctors_Names[i];
        } else {
          doctors_names = doctors_names + Doctors_Names[i];
        }
      }
    }

    final viewFilesTypes = Icon(
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
              border: DashedBorder.all(
                color: is_Dark!.getString('is_dark') == 'true'
                    ? Colors.green
                    : Colors.blue,
                dashLength: 120,
                width: 7,
                isOnlyCorner: true,
                strokeAlign: BorderSide.strokeAlignInside,
                strokeCap: StrokeCap.round,
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
            height: height / 3,
            child: Stack(
              children: [
                // image for the year :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Type + ' :',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width / 12,
                          ),
                    ),
                    Text(
                      Type == "Practical" ? Doctors_Names ?? '' : doctors_names,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width / 25,
                          ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: width / 2.5,
                      ),
                      child: Image(
                        width: width / 3.4,
                        height: height / 5.4,
                        image: AssetImage(path),
                      ),
                    ),
                  ],
                ),
                // Button To go to subjects screen :
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: width / 3,
                    height: width / 6,
                    decoration: BoxDecoration(
                      color:
                          Themes.colorScheme.onPrimaryContainer.withOpacity(.8),
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
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: width / 12,
                                    color: Colors.white,
                                  ),
                        ),
                        SizedBox(width: width / 20),
                        GetBuilder<HomeController>(
                          id: 'viewSubject',
                          init: HomeController(),
                          builder: (hController) {
                            return InkWell(
                              onTap: () {
                                hController.viewFilesTypes(
                                    Type, subject_name, year, index);
                              },
                              child: hController.circleViewFilesTypes ??
                                  viewFilesTypes,
                            );
                          },
                        )
                      ],
                    ),
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
