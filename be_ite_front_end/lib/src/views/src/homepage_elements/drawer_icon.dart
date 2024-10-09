// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Dark_mode_Controller.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Page_Controllers/Drawer_Controller.dart';

import 'package:public_testing_app/src/models/Themes.dart';

class drawerIcon extends StatelessWidget {
  const drawerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DarkModeController>(
      init: DarkModeController(),
      builder: (controller) => Builder(
        builder: (context) {
          return GetBuilder<DrawersController>(
              init: DrawersController(),
              builder: (drawer_controller) {
                return IconButton(
                  onPressed: () {
    
                    if (Auth!.getString("user") == "active_student") {
                      drawer_controller.getUserPhoto("get-student-photo");
                    } else if (Auth!.getString("user") == "active_doctor") {
                      drawer_controller.getUserPhoto("get-doctor-photo");
                    } else if (Auth!.getString("user") == "active_teacher") {
                      drawer_controller.getUserPhoto("get-teacher-photo");
                    }
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image(
                    height: Themes.getWidth(context) / 12,
                    width: Themes.getWidth(context) / 10,
                    color: is_Dark!.getString('is_dark') == 'true'
                        ? Themes.darkColorScheme.primary
                        : Themes.colorScheme.primary,
                    image: const AssetImage('assets/images/option.png'),
                  ),
                );
              });
        },
      ),
    );
  }
}
