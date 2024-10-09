// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/views/src/Home/first_Page/Recent_Files/Recent_Files_Card.dart';
import 'package:uuid/uuid.dart';


class RecentFiles extends StatelessWidget {
  const RecentFiles({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    const uuid = Uuid();
    final controller = Get.put(HomeController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: appData!.getBool('isSeeAll')! ? height / 3.5 : height / 15,
        ),
        Image(
          width: !appData!.getBool('isSeeAll')! ? width / 4 : width / 3,
          height: !appData!.getBool('isSeeAll')! ? height / 8 : height / 6,
          image: const AssetImage('assets/images/error-404.png'),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'No Recent Files',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // recent files keyword :
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  'Recent Files :',
                  style: appData!.getBool('isSeeAll')!
                      ? Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width * 0.06,
                          )
                      : Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: width * 0.05,
                          ),
                ),
              ),
              // is see all :
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: InkWell(
                        onTap: onTap,
                        child: Text(
                          appData!.getBool('isSeeAll')! ? 'Hide' : 'see all',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontSize: width * 0.05,
                                    color: Colors.blueAccent,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GetBuilder<HomeController>(
          id: 'recent_files',
          init: HomeController(),
          builder: (bt_nav_controller) {
            return appData!.getBool("not_empty_recent_files") == false
                ? content
                : Expanded(
                    child: ListView.builder(
                      itemCount:
                          appData!.getStringList("recent_files_names")!.length,
                      itemBuilder: (ctx, index) {
                        return Dismissible(
                          background: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Themes.colorScheme.error.withOpacity(0.8),
                            ),
                            margin: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    "Delete",
                                    style: Get.textTheme.titleLarge!.copyWith(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          key: ValueKey(DateTime.now()),
                          onDismissed: (direction) {
                            controller.remove_from_recent_files(
                                appData!.getStringList(
                                    "recent_files_names")![index],
                                appData!.getStringList(
                                    "recent_files_paths")![index]);
                          },
                          child: RecentFilesCard(
                            index: index,
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
      ],
    );
  }
}
