import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/first_Page/Recent_Files/OpenRecentfile.dart';

class RecentFilesCard extends StatelessWidget {
  const RecentFilesCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);
    final HomeController controller = Get.find();

    Widget open = InkWell(
      onTap: () {
        Get.to(
          () => OpenRecentfile(
            file_path: appData!.getStringList("recent_files_paths")![index],
          ),
        );
      },
      child: const Icon(
        Iconsax.folder_open,
        size: 30,
        color: Colors.white,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Themes.getColor(
                Themes.darkColorScheme.primaryContainer.withOpacity(.7),
                Colors.blue.withOpacity(.5),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              border: Border.all(
                color: Themes.getColor(
                    Themes.darkColorScheme.primary, Themes.colorScheme.primary),
                width: 3,
              ),
            ),
            width: width,
            height: height / 12,
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  left: 10,
                  child: Text(
                    '${index + 1} . ',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 15),
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 30,
                  child: SizedBox(
                    width: 260,
                    child: SingleChildScrollView(
                      child: Text(
                        appData!.getStringList("recent_files_names")![index],
                        style: Get.textTheme.titleLarge!.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: controller.download_circle == null
                        ? width / 8
                        : width / 6,
                    height: width / 8,
                    decoration: BoxDecoration(
                      color: Themes.colorScheme.onPrimaryContainer,
                      border: Border.all(
                        width: 3,
                        color: Themes.getColor(Colors.white, Colors.white),
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Themes.getColor(Colors.green, Colors.blue),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: open,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
