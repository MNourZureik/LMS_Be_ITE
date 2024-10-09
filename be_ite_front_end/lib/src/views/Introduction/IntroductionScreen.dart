// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:public_testing_app/src/controllers/Dark_mode_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

DarkModeController controller = Get.put(DarkModeController());

class IntroductionScreens extends StatelessWidget {
  const IntroductionScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Themes.getColor(Themes.darkColorScheme.background, Colors.white),
        body: IntroductionScreen(
          globalBackgroundColor:
              Themes.getColor(Themes.darkColorScheme.background, Colors.white),
          pages: [
            PageViewModel(
              decoration: const PageDecoration(
                imageFlex: 2,
              ),
              titleWidget: Text(
                'Welcome To The ITE Learning Management System !',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: Themes.getWidth(context) / 20,
                    ),
                textAlign: TextAlign.center,
              ),
              bodyWidget: Text(
                textAlign: TextAlign.center,
                'Stay organized and save time with our streamlined LMS.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: Themes.getWidth(context) / 30,
                    ),
              ),
              image: Lottie.asset(
                'assets/json/First.json',
                width: Themes.getWidth(context),
                height: MediaQuery.of(context).size.height,
              ),
            ),
            PageViewModel(
              decoration: const PageDecoration(
                imageFlex: 2,
              ),
              titleWidget: Text(
                'Simplify your teaching and enhance student engagement with our user-friendly LMS designed exclusively for ITE Engineering faculty.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: Themes.getWidth(context) / 20,
                    ),
                textAlign: TextAlign.center,
              ),
              bodyWidget: const Text(''),
              image: Lottie.asset(
                'assets/json/Second.json',
                width: Themes.getWidth(context),
                height: MediaQuery.of(context).size.height,
              ),
            ),
            PageViewModel(
              decoration: const PageDecoration(
                imageFlex: 2,
              ),
              titleWidget: Text(
                'Prepare ITE Engineering students for real-world challenges with our LMS.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: Themes.getWidth(context) / 20,
                    ),
                textAlign: TextAlign.center,
              ),
              bodyWidget: Text(
                textAlign: TextAlign.center,
                'Stay informed about everything happening in your college.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: Themes.getWidth(context) / 30,
                    ),
              ),
              image: Lottie.asset(
                'assets/json/Fourth.json',
                width: Themes.getWidth(context),
                height: MediaQuery.of(context).size.height,
              ),
            ),
            PageViewModel(
              decoration: const PageDecoration(
                imageFlex: 2,
              ),
              titleWidget: Text(
                'are you ready ?',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: Themes.getWidth(context) / 20,
                    ),
                textAlign: TextAlign.center,
              ),
              bodyWidget: Text(
                textAlign: TextAlign.center,
                'press GetStarted to begin',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: Themes.getWidth(context) / 30,
                    ),
              ),
              image: Lottie.asset(
                'assets/json/Third.json',
                width: Themes.getWidth(context),
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ],
          showNextButton: true,
          next: Text(
            'Next',
            style: TextStyle(
              fontSize: Themes.getWidth(context) / 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          showSkipButton: true,
          skipStyle: TextButton.styleFrom(
            foregroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(.5),
            backgroundColor: Colors.grey.withOpacity(.2),
          ),
          skip: Text(
            'Skip',
            style: TextStyle(
              fontSize: Themes.getWidth(context) / 20,
            ),
          ),
          showDoneButton: true,
          onDone: () {
            Get.offNamed('EmailPageScreen');
          },
          done: Text(
            'Get Started',
            style: TextStyle(
              fontSize: Themes.getWidth(context) / 25,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Themes.getColor(Colors.white60, Colors.black54),
            activeColor: Themes.getColor(
                Themes.darkColorScheme.primary, Themes.colorScheme.primary),
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
