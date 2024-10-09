import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class IntroAI extends StatelessWidget {
  const IntroAI({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Your AI Assistant',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Using this software , you can ask him questions and recieve articals using artificial intelligence assistant',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const SizedBox(height: 32),
          Image.asset(
            'assets/images/assistant.png',
            width: Themes.getWidth(context) / 1.2,
            height: Themes.getWidth(context) / 1.2,
          ).animate(effects: [
            const FadeEffect(),
          ]),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('AI_Route');
            },
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 32,
              ),
              backgroundColor: is_Dark!.getString('is_dark') == 'true'
                  ? const Color(0xff73C481)
                  : Themes.colorScheme.primary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Continue',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 30),
                const Icon(
                  Iconsax.arrow_right,
                  color: Colors.white,
                  size: 35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
