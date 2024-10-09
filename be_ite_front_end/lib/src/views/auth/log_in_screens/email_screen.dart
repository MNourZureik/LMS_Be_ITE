// ignore_for_file: file_names, body_might_complete_normally_nullable, invalid_use_of_protected_member, non_constant_identifier_names, unused_local_variable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/widgets/ElevatedButton.dart';
import 'package:public_testing_app/src/controllers/Auth_Controllers/email_Controller.dart';
import 'package:public_testing_app/src/widgets/TextFormField.dart';
import 'package:public_testing_app/src/models/Themes.dart';

import '../Elements_For_Auth/Custom_Shape_top.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailController controller = Get.put(EmailController());

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Themes.getColor(
            Themes.darkColorScheme.primary, Themes.colorScheme.primary),
        systemNavigationBarColor: Themes.getColor(
            Themes.darkColorScheme.primary, Themes.colorScheme.primary),
      ),
    );
    Widget check = Text(
      'Check',
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: Themes.getWidth(context) / 22,
            color: Colors.white,
          ),
    );

    Widget circle = const CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
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
                      top: 130,
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
                const SizedBox(height: 100),
                // Some Text
                Text(
                  'Log in',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: Themes.getWidth(context) / 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
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
                      // Email Text Field :
                      MyTextFormField(
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "email required";
                          }
                          int index = 0;
                          for (int i = 0; i < value.length; i++) {
                            if (value[i] == '@') {
                              index = i;
                              break;
                            }
                          }
                          String email = value.substring(0, index);
                          if (int.tryParse(email) != null ||
                              double.tryParse(email) != null ||
                              email.length < 5) {
                            return "invalid email";
                          }
                        },
                        save: (value) {
                          controller.email.text = value!;
                        },
                        keyboard: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: 'Enter your ITE email',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Login Button :
                GetBuilder<EmailController>(
                  init: EmailController(),
                  builder: (circle_controller) {
                    return MyElevetedButton(
                      onTap: () {
                        controller.onSave();
                      },
                      widget: circle_controller.circle == true ? circle : check,
                      width: 3.6,
                      height: 35,
                      BackColor:
                          Theme.of(context).colorScheme.primary.withOpacity(.7),
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
