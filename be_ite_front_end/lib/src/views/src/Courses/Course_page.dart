// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Courses_Controllers/Courses_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Courses/Video_Player.dart';

// ignore: must_be_immutable
class Course extends StatelessWidget {
  const Course({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final cs_controller = Get.put(CoursesController());
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);

    return Scaffold(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
      appBar: AppBar(
        backgroundColor: Themes.getColor(
            Themes.darkColorScheme.background.withOpacity(.9), Colors.white),
        title: Text(
          '${cs_controller.name[index]} :',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.normal,
                fontFamily: 'PoetsenOne',
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GetBuilder<CoursesController>(
          id: 'section',
          init: CoursesController(),
          builder: (controller) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: height / 4,
                  width: width,
                  decoration: BoxDecoration(
                    color: cs_controller.colors[index].withOpacity(.3),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage(cs_controller.path[index]),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: 45,
                          color: cs_controller.colors[index],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${cs_controller.name[index]} complete course',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text(
                  cs_controller.desc[index],
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.isVideoSection = true;
                        controller.isDiscryption = false;
                        controller.update(['section']);
                      },
                      child: Container(
                        width: width / 3,
                        height: width / 7.3,
                        decoration: BoxDecoration(
                          color: controller.isVideoSection
                              ? Themes.colorScheme.onPrimaryContainer
                              : Themes.colorScheme.onPrimaryContainer
                                  .withOpacity(.3),
                          border: Border.all(
                            width: 3,
                            color: Themes.getColor(Colors.white, Colors.white),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Themes.getColor(Colors.green, Colors.blue),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Videos',
                            style: Get.textTheme.titleLarge!.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'PoetsenOne',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.isVideoSection = false;
                        controller.isDiscryption = true;
                        controller.update(['section']);
                      },
                      child: Container(
                        width: width / 3,
                        height: width / 7.3,
                        decoration: BoxDecoration(
                          color: controller.isDiscryption
                              ? Themes.colorScheme.onPrimaryContainer
                              : Themes.colorScheme.onPrimaryContainer
                                  .withOpacity(.3),
                          border: Border.all(
                            width: 3,
                            color: Themes.getColor(Colors.white, Colors.white),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Themes.getColor(Colors.green, Colors.blue),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Discryption',
                            style: Get.textTheme.titleLarge!.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'PoetsenOne',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                cs_controller.isVideoSection
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: cs_controller.videos.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: GetBuilder<CoursesController>(
                                builder: (controller) {
                                  return Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: cs_controller.colors[index],
                                        shape: BoxShape.circle),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => const VideoPlay());
                                      },
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              title: Text('${cs_controller.videos[i]}'),
                              subtitle: Text('${cs_controller.subtitle[i]}'),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: width - 50,
                        height: width * 0.8,
                        decoration: BoxDecoration(
                          color: Themes.getColor(
                              Themes.colorScheme.onPrimaryContainer
                                  .withOpacity(.3),
                              Themes.colorScheme.onPrimaryContainer),
                          border: Border.all(
                            width: 3,
                            color: cs_controller.colors[index],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Text(
                              'This Course For biggeners to get python from scratch to advanced.',
                              style: Get.textTheme.titleLarge!.copyWith(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'PoetsenOne',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
