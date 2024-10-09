import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/homepage_elements/Drawer_Elements.dart/subject_downloaded_files.dart';

class DownloadedFiles extends StatefulWidget {
  const DownloadedFiles({super.key});

  @override
  State<DownloadedFiles> createState() => _DownloadedFilesState();
}

class _DownloadedFilesState extends State<DownloadedFiles> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeController>(
        id: "file_downloaded",
        init: HomeController(),
        builder: (ctrl) {
          final subjects = appData!.getStringList("subjects");
          return Scaffold(
            backgroundColor: is_Dark!.getString('is_dark') == 'true'
                ? Themes.darkColorScheme.background.withOpacity(.9)
                : Colors.white,
            appBar: AppBar(
              backgroundColor: is_Dark!.getString('is_dark') == 'true'
                  ? Themes.darkColorScheme.background
                  : Themes.colorScheme.primaryContainer,
              title: const Text("Downloaded Files :"),
            ),
            body: subjects!.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          width: 150,
                          height: 150,
                          image: AssetImage("assets/images/error-404.png"),
                        ),
                        SizedBox(height: 20),
                        Text("no downloaded files yet!"),
                      ],
                    ),
                  )
                : GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                    ),
                    children: [
                      for (int i = 0; i < subjects.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                () => SubjectDownloadedFiles(
                                  subject: subjects[i],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 2,
                                  ),
                                ],
                                color: Themes.getColor(
                                  Themes.darkColorScheme.primary,
                                  Themes.colorScheme.primary,
                                ),
                              ),
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 15,
                                      left: 15,
                                      child: Text(
                                        subjects[i],
                                        style:
                                            Get.textTheme.titleLarge!.copyWith(
                                          color: Themes.getColor(
                                            Colors.black,
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      right: 15,
                                      child: InkWell(
                                        onTap: () {
                                          final subjects = appData!
                                              .getStringList("subjects");
                                          subjects!.remove(subjects[i]);

                                          appData!.setStringList(
                                              "subjects", subjects);
                                          appData!.setStringList(
                                              "files[${subjects[i]}]", []);
                                          appData!.setStringList(
                                              "names[${subjects[i]}]", []);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Iconsax.trash,
                                          size: 30,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
          );
        },
      ),
    );
  }
}
