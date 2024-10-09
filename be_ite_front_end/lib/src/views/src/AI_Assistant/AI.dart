import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Personal_Assistant_AI_Controller/AI_controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class AI extends StatelessWidget {
  const AI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIController());
    ImageProvider getUserImageForChat() {
      String? photo = appData!.getString("user_photo");
      if (photo == null || photo == '') {
        if (Auth!.getString('user') == "active_student") {
          return const AssetImage("assets/images/student.png");
        } else {
          return const AssetImage("assets/images/student.png");
        }
      }
      return FileImage(File(photo));
    }

    return WillPopScope(
      onWillPop: () => controller.onWillPop(),
      child: Scaffold(
        backgroundColor: is_Dark!.getString('is_dark') == 'true'
            ? Themes.darkColorScheme.background.withOpacity(.9)
            : Colors.white,
        appBar: AppBar(
          backgroundColor: is_Dark!.getString('is_dark') == 'true'
              ? Themes.darkColorScheme.background
              : Themes.colorScheme.primaryContainer,
          elevation: 3,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/robot.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your AI Assistant :",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  GetBuilder<AIController>(
                      id: "state",
                      init: AIController(),
                      builder: (controller_ai) {
                        return Text(
                          controller_ai.state,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: controller.state == "online"
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                        );
                      })
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<AIController>(
                init: AIController(),
                builder: (ai_controller) {
                  return ai_controller.messages.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage("assets/images/ai.png"),
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Start Your Conversation Now !")
                          ],
                        )
                      : ListView.builder(
                          itemCount: ai_controller.messages.length,
                          itemBuilder: (context, index) {
                            final message = ai_controller.messages[index];

                            return message.isUser
                                ? ListTile(
                                    title: Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: getUserImageForChat(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 9.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: is_Dark!.getString(
                                                            'is_dark') ==
                                                        'true'
                                                    ? Colors.green
                                                    : Colors.blue,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                              child: Text(
                                                message.text,
                                                style: TextStyle(
                                                    color: message.isUser
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : message.loading ??
                                    ListTile(
                                      title: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 3),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/robot.png'),
                                                width: 15,
                                                height: 15,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: message.isUser
                                                      ? Colors.blue
                                                      : Colors.grey[300],
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: Text(
                                                  message.text,
                                                  style: TextStyle(
                                                      color: message.isUser
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                          },
                        );
                },
              ),
            ),
            // USER INPUT :
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 32, top: 16, left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.black,
                            ),
                        controller: controller.controller,
                        decoration: const InputDecoration(
                          hintText: 'Write your message here ...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: controller.callGiminiModel,
                        child: const Icon(Iconsax.send_14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
