// ignore_for_file: body_might_complete_normally_nullable, unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:public_testing_app/src/widgets/ElevatedButton.dart';
import 'package:public_testing_app/src/controllers/Auth_Controllers/set_pass/verification_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/main.dart';
import '../Elements_For_Auth/Custom_Shape_top.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VerificationController controller = Get.put(VerificationController());

    Widget confirm = Text(
      'Confirm',
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: Themes.getWidth(context) / 22, color: Colors.white),
    );

    return SafeArea(
      child: GetBuilder<VerificationController>(
        id: 'will_pop_scope',
        init: VerificationController(),
        builder: (will_pop_controller) {
          return WillPopScope(
            onWillPop: () async => will_pop_controller.willPopScope,
            child: Scaffold(
              backgroundColor: Themes.getColor(
                  Themes.darkColorScheme.background, Colors.white),
              body: SizedBox(
                width: Themes.getWidth(context),
                height: Themes.getHeight(context),
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
                            top: 120,
                            right: 0,
                            left: 0,
                            child: Image(
                              image: const AssetImage(
                                  'assets/images/programmer.png'),
                              width: Themes.getWidth(context) / 3.5,
                              height: MediaQuery.of(context).size.height / 6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Verification Code',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: Themes.getWidth(context) / 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'enter the code that we have sent to your email ${Auth!.getString('email')}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: Themes.getWidth(context) / 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: Themes.getWidth(context) / 0.75,
                        child: Form(
                          key: controller.Form_Key,
                          child: Pinput(
                            length: 6,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            defaultPinTheme: PinTheme(
                              height: Themes.getWidth(context) / 8,
                              width: Themes.getWidth(context) / 7.7,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'code required';
                              } else if (int.tryParse(value) == null) {
                                return 'enter a valid code';
                              } else if (value.length != 6) {
                                return 'complete the code';
                              }
                            },
                            onCompleted: (value) {
                              controller.code.text = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Themes.getWidth(context) / 15),
                        child: Row(
                          children: [
                            Text(
                              'doesn`t recieve any code?',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 5),
                            GetBuilder<VerificationController>(
                                id: 'resend_code',
                                init: VerificationController(),
                                builder: (timeController) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (timeController.remainingSeconds <=
                                          0) {
                                        timeController.willPopScope = false;
                                        timeController.timer!.cancel();
                                        timeController.counter++;
                                        timeController.onReady();
                                        timeController.update(['resend_code']);
                                        controller.ResendCode();
                                      }
                                    },
                                    child: timeController.remainingSeconds <= 0
                                        ? Text(
                                            'Resend code',
                                            style: controller.counter > 3
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue,
                                                    ),
                                          )
                                        : Text(
                                            'Resend code',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                  );
                                }),
                            SizedBox(width: Themes.getWidth(context) / 6),
                            GetX<VerificationController>(
                              init: VerificationController(),
                              builder: (controller) => Text(
                                controller.time.value,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Login Button :
                      GetBuilder<VerificationController>(
                          id: 'circleIndicater',
                          init: VerificationController(),
                          builder: (verify_controller) {
                            return MyElevetedButton(
                              onTap: () {
                                controller.onSave();
                              },
                              width: 3.6,
                              height: 35,
                              BackColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.7),
                              widget: verify_controller.circle ?? confirm,
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
