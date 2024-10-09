import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/fifth_Page/OpenFile.dart';

class SavedFilesCard extends StatelessWidget {
  const SavedFilesCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final width = Themes.getWidth(context);
    final height = Themes.getHeight(context);
    final HomeController controller = Get.find();

    Widget remove_from_saved_files = InkWell(
      onTap: () {
        int id = controller.savedFiles_information[index]["id"];
        controller.remove_saved_file(context, id);
        controller.update_timer(id, index);
      },
      child: const Icon(
        Iconsax.trash,
        size: 30,
        color: Colors.redAccent,
      ),
    );

    Widget open = controller.download_circle ??
        InkWell(
          onTap: () {
            String path = appData!.getString(
                "file[${controller.savedFiles_information[index]["type"].toLowerCase()}][${controller.saved_files_ids[index]}]")!;
            String name = controller.savedFiles_information[index]["name"];
            Get.to(
              () => Openfile(
                file_path: path,
              ),
            );
            controller.add_to_recent_files(name, path);
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
            height: height / 4.5,
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Themes.getColor(
                          Themes.darkColorScheme.primary,
                          Themes.colorScheme.primary,
                        ),
                      ),
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: Get.textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    '1.name : ${controller.savedFiles_information[index]["name"]}',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 18),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Text(
                    '2.type : ${controller.savedFiles_information[index]["type"]}',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 18),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 10,
                  child: Text(
                    '3.subject : ${controller.savedFiles_information[index]["subject"]}',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 18),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 10,
                  child: Text(
                    '4.year : ${controller.savedFiles_information[index]["year"]}',
                    style: Get.textTheme.titleLarge!.copyWith(fontSize: 18),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GetBuilder<HomeController>(
                      id: 'saved_files_download[$index]',
                      init: HomeController(),
                      builder: (context) {
                        return Container(
                          width: width / 8,
                          height: width / 8,
                          decoration: BoxDecoration(
                            color: Themes.colorScheme.onPrimaryContainer,
                            border: Border.all(
                              width: 3,
                              color:
                                  Themes.getColor(Colors.white, Colors.white),
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Themes.getColor(Colors.green, Colors.blue),
                                blurStyle: BlurStyle.outer,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: appData!.getString(
                                      "file[${controller.savedFiles_information[index]["type"].toLowerCase()}][${controller.saved_files_ids[index]}]") ==
                                  null
                              ? controller.download_circle ??
                                  InkWell(
                                    onTap: () {
                                      controller.download_saved_file(
                                          index,
                                          controller
                                              .savedFiles_information[index]
                                                  ["type"]
                                              .toLowerCase());
                                    },
                                    child: const Icon(
                                      Iconsax.document_download,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                              : open,
                        );
                      }),
                ),
                Positioned(
                  bottom: 10,
                  right: 70,
                  child: GetBuilder<HomeController>(
                    id: 'saved_files',
                    init: HomeController(),
                    builder: (controller) {
                      return Container(
                        width: width / 8,
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
                        child: remove_from_saved_files,
                      );
                    },
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
