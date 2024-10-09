import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/fifth_Page/OpenFile.dart';

class SubjectDownloadedFiles extends StatelessWidget {
  const SubjectDownloadedFiles({super.key, required this.subject});

  final String subject;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeController>(
          id: "file_downloaded",
          init: HomeController(),
          builder: (ctrl) {
            final length = appData!.getStringList("files[$subject]")!.length;
            final files = appData!.getStringList("files[$subject]");
            final names = appData!.getStringList("names[$subject]");
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
              body: length == 0
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
                  : ListView.builder(
                      itemCount: length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.white,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: Themes.getColor(
                                Themes.darkColorScheme.primary,
                                Themes.colorScheme.primary,
                              ),
                            ),
                            child: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 230,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        names![index],
                                        style:
                                            Get.textTheme.titleLarge!.copyWith(
                                          fontSize: 15,
                                          color: Themes.getColor(
                                            Colors.black,
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: Themes.getWidth(context) / 8,
                                      height: Themes.getWidth(context) / 9,
                                      decoration: BoxDecoration(
                                        color: Themes
                                            .colorScheme.onPrimaryContainer,
                                        border: Border.all(
                                          width: 3,
                                          color: Themes.getColor(
                                              Colors.white, Colors.white),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Themes.getColor(
                                                Colors.green, Colors.blue),
                                            blurStyle: BlurStyle.outer,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (length == 1) {
                                            final subjects = appData!
                                                .getStringList("subjects");
                                            subjects!.remove(subject);

                                            appData!.setStringList(
                                                "subjects", subjects);
                                          }

                                          final files = appData!
                                              .getStringList("files[$subject]");
                                          files!.remove(files[index]);
                                          appData!.setStringList(
                                              "files[$subject]", files);

                                          final names = appData!
                                              .getStringList("names[$subject]");
                                          names!.remove(names[index]);
                                          appData!.setStringList(
                                              "names[$subject]", names);

                                          final controller =
                                              Get.put(HomeController());
                                          controller
                                              .update(["file_downloaded"]);
                                          controller
                                              .update(["file_downloaded"]);
                                          controller
                                              .update(["file_downloaded"]);
                                        },
                                        child: const Icon(
                                          Iconsax.trash,
                                          size: 25,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: Themes.getWidth(context) / 8,
                                      height: Themes.getWidth(context) / 9,
                                      decoration: BoxDecoration(
                                        color: Themes
                                            .colorScheme.onPrimaryContainer,
                                        border: Border.all(
                                          width: 3,
                                          color: Themes.getColor(
                                              Colors.white, Colors.white),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Themes.getColor(
                                                Colors.green, Colors.blue),
                                            blurStyle: BlurStyle.outer,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => Openfile(
                                              file_path: files![index],
                                            ),
                                          );

                                          HomeController().add_to_recent_files(
                                              names[index], files![index]);
                                        },
                                        child: const Icon(
                                          Iconsax.folder_open,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            );
          }),
    );
  }
}
