// ignore_for_file: file_names, body_might_complete_normally_nullable, invalid_use_of_protected_member, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/widgets/ElevatedButton.dart';
import 'package:public_testing_app/src/controllers/Auth_Controllers/login/login_pass_Controller.dart';
import 'package:public_testing_app/src/widgets/TextFormField.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import '../Elements_For_Auth/Custom_Shape_top.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginPassController controller = Get.put(LoginPassController());

    Widget logIn = Text(
      'Log in',
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: Themes.getWidth(context) / 22, color: Colors.white),
    );
    // forgot password :
    List<Widget> content = [
      const SizedBox(height: 15),
      // Forgot PassWord :
      Padding(
        padding: const EdgeInsets.only(right: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed('VerificationPageScreen');
                controller.onForgotPassword();
              },
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: Themes.getWidth(context) / 25,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Themes.getColor(Themes.darkColorScheme.background, Colors.white),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CustomShapeTop(),
                    Positioned(
                      top: 100,
                      right: 0,
                      left: 0,
                      child: Image(
                        image: const AssetImage('assets/images/programmer.png'),
                        width: Themes.getWidth(context) / 3.5,
                        height: Themes.getHeight(context) / 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Some Text
                Text(
                  'Log in',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: Themes.getWidth(context) / 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Welcome Back !',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: Themes.getWidth(context) / 28),
                ),
                const SizedBox(height: 15),
                // Informations Fields :
                Form(
                  key: controller.Form_Key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //user name text field :
                      MyTextFormField(
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "user name missing";
                          }
                          if (value.trim().length < 3) {
                            return "user name too short";
                          }
                          if (int.tryParse(value) != null) {
                            return 'invalid username';
                          }
                        },
                        save: (value) {
                          controller.user_name.text = value!;
                        },
                        keyboard: TextInputType.text,
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: 'User name',
                      ),
                      const SizedBox(height: 10),
                      // PassWord Text Field :
                      GetBuilder<LoginPassController>(
                        init: LoginPassController(),
                        builder: (ctr) {
                          return MyTextFormField(
                            validate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "password missing";
                              }
                              if (value.trim().length < 8) {
                                return "password too short";
                              }
                            },
                            save: (value) {
                              controller.pass_word.text = value!;
                            },
                            Pass_Security: ctr.isSecurePassword,
                            keyboard: TextInputType.text,
                            suffixIcon: ctr.togglePassWord(),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: 'Enter password',
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ...content,
                const SizedBox(height: 15),
                // Login Button :
                GetBuilder<LoginPassController>(
                  id: 'CILPass',
                  init: LoginPassController(),
                  builder: (circle_controller) {
                    return MyElevetedButton(
                      onTap: () => controller.onSave(),
                      width: 3.6,
                      height: 35,
                      BackColor:
                          Theme.of(context).colorScheme.primary.withOpacity(.7),
                      widget: circle_controller.circle ?? logIn,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
