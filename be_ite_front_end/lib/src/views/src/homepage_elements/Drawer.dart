// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/widgets/ListTile.dart';
import 'package:public_testing_app/src/controllers/Home_Page_Controllers/Drawer_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/controllers/Auth_Controllers/change_pass/change_pass_controller.dart';
import 'package:public_testing_app/src/controllers/Auth_Controllers/logout_Controller.dart';
import 'package:public_testing_app/main.dart';

final class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final logout_controller = Get.put(LogoutController());
    final changePass_controller = Get.put(ChangePassController());
    final drawer_controller = Get.put(DrawersController());

    List<Widget> content = [];
    if (Auth!.getString("user") == "active_student") {
      final HomeController h_controller = Get.find();
      content = [
        MyListTile(
          label: 'Saved Files',
          onTap: () {
            h_controller.getStudentSavedFiles();
            Get.toNamed('saved_files');
            Scaffold.of(context).closeDrawer();
          },
          prefix: Image(
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/images/bookmark.png'),
          ),
        ),
        MyListTile(
          label: 'Downloaded Files',
          onTap: () {
            Get.toNamed('downloaded_files');
            Scaffold.of(context).closeDrawer();
          },
          prefix: Image(
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/images/save.png'),
          ),
        ),
        MyListTile(
          label: 'Change Password',
          onTap: () {
            Get.toNamed('ChangePassPageScreen');
            Scaffold.of(context).closeDrawer();
          },
          prefix: Image(
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/images/reset-password.png'),
          ),
        ),
        MyListTile(
          label: 'Edit Profile',
          onTap: () {
            Get.toNamed('EditProfilePageScreen');
            Scaffold.of(context).closeDrawer();
          },
          prefix: Image(
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            image: const AssetImage('assets/images/edit.png'),
          ),
        ),
        MyListTile(
          label: 'Log Out',
          onTap: () {
            logout_controller.onLogOut();
          },
          prefix: Image(
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/images/logout.png'),
          ),
        ),
      ];
    } else {
      content = [
        MyListTile(
          label: 'Change Password',
          onTap: () {
            Get.toNamed('ChangePassPageScreen');
            Scaffold.of(context).closeDrawer();
          },
          prefix: Image(
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/images/reset-password.png'),
          ),
        ),
        MyListTile(
          label: 'Edit Profile',
          onTap: () {
            Get.toNamed('EditProfilePageScreen');
            Scaffold.of(context).closeDrawer();
          },
          prefix: Image(
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            image: const AssetImage('assets/images/edit.png'),
          ),
        ),
        MyListTile(
          label: 'Log Out',
          onTap: () {
            logout_controller.onLogOut();
          },
          prefix: Image(
            height: Themes.getWidth(context) / 12,
            width: Themes.getWidth(context) / 10,
            color: is_Dark!.getString('is_dark') == 'true'
                ? Colors.white
                : Colors.black,
            image: const AssetImage('assets/images/logout.png'),
          ),
        ),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Themes.getWidth(context) / 5),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(150),
            topRight: Radius.circular(25),
          ),
        ),
        backgroundColor: is_Dark!.getString('is_dark') == 'true'
            ? Themes.darkColorScheme.secondaryContainer
            : Themes.colorScheme.primaryContainer,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.only(top: Themes.getWidth(context) / 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CircleAvatar(
                      backgroundColor: is_Dark!.getString('is_dark') == 'true'
                          ? Colors.white
                          : Colors.black,
                      radius: Themes.getWidth(context) / 9,
                      child: GetBuilder<DrawersController>(
                        id: 'user_picture',
                        init: DrawersController(),
                        builder: (dr_controller) {
                          return appData!.getString('user_photo') != '' &&
                                  (appData!.getString('user_photo') != null)
                              ? CircleAvatar(
                                  radius: Themes.getWidth(context) / 9.5,
                                  backgroundImage: FileImage(
                                    File(appData!.getString('user_photo')!),
                                  ),
                                )
                              : Auth!.getString("user") == "active_student"
                                  ? CircleAvatar(
                                      radius: Themes.getWidth(context) / 4.1,
                                      backgroundImage: const AssetImage(
                                        'assets/images/student.png',
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: Themes.getWidth(context) / 4.1,
                                      backgroundImage: const AssetImage(
                                        'assets/images/teacher.png',
                                      ),
                                    );
                        },
                      ),
                    ),
                  ),
                  Text(
                    Auth!.getString('user_name')!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: Themes.getWidth(context) / 20,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    Auth!.getString('email')!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: Themes.getWidth(context) / 35,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            ...content
          ],
        ),
      ),
    );
  }
}
