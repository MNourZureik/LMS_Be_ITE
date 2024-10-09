import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/homepage_elements/Drawer_Elements.dart/Saved_Files_Card.dart';

class SavedFiles extends StatelessWidget {
  const SavedFiles({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController h_controller = Get.find();
    return Scaffold(
      backgroundColor: Themes.getColor(
        Themes.darkColorScheme.background.withOpacity(.9),
        Colors.white,
      ),
      appBar: AppBar(
        title: Text(
          'Saved Files :',
          style: Get.textTheme.titleLarge,
        ),
        backgroundColor: Themes.getColor(
          Themes.darkColorScheme.background.withOpacity(.9),
          Colors.white,
        ),
      ),
      body: GetBuilder<HomeController>(
        id: "student_saved_files",
        builder: (controller) {
          return h_controller.savedFiles_information.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        width: 100,
                        height: 100,
                        image: AssetImage('assets/images/error-404.png'),
                      ),
                      Text(
                        'No files added yet',
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: h_controller.savedFiles_information.length,
                        itemBuilder: (ctx, index) {
                          return SavedFilesCard(
                            index: index,
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
