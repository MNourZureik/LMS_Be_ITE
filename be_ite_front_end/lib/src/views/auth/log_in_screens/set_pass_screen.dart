// ignore_for_file: file_names, body_might_complete_normally_nullable, invalid_use_of_protected_member, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/widgets/ElevatedButton.dart';
import 'package:public_testing_app/src/widgets/TextFormField.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/controllers/Auth_Controllers/set_pass/set_pass_Controller.dart';
import '../Elements_For_Auth/Custom_Shape_top.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPassController controller = Get.put(RegisterPassController());

    Widget register = Text(
      'Register',
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: Themes.getWidth(context) / 22, color: Colors.white),
    );
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
                  'Set Password',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: Themes.getWidth(context) / 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Glad To Meet You !',
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
                      GetBuilder<RegisterPassController>(
                        init: RegisterPassController(),
                        builder: (ctr) {
                          return MyTextFormField(
                            validate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "password required";
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
                            label: 'password',
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      //confirm PassWord Text Field :
                      GetBuilder<RegisterPassController>(
                        init: RegisterPassController(),
                        builder: (ctr) {
                          return MyTextFormField(
                            validate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "confirm password required";
                              }
                              if (value.trim().length < 8) {
                                return "password too short";
                              }
                            },
                            save: (value) {
                              controller.confirm_pass_word.text = value!;
                            },
                            Pass_Security: ctr.isSecurePasswordConfirm,
                            keyboard: TextInputType.text,
                            suffixIcon: ctr.toggleConfirmPassWord(),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: 'confirm password',
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // register Button :
                GetBuilder<RegisterPassController>(
                  id: 'CIRPass',
                  init: RegisterPassController(),
                  builder: (circle_controller) {
                    return MyElevetedButton(
                      onTap: () => controller.onSave(),
                      width: 3.6,
                      height: 35,
                      BackColor:
                          Theme.of(context).colorScheme.primary.withOpacity(.7),
                      widget: circle_controller.circle ?? register,
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
