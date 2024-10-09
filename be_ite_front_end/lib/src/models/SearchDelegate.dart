
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/Courses_Controllers/Courses_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

import 'package:public_testing_app/src/views/src/Courses/Course_page.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<dynamic> Filternames = [];
  List<dynamic> FilterImages = [];
  List<dynamic> FilterDesc = [];
  final cs_controller = Get.put(CoursesController());

  @override
  String get searchFieldLabel => 'Search ...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: Themes.getColor(Colors.white, Colors.black),
        ),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Themes.getColor(Colors.white, Colors.black),
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('');
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Themes.getColor(
          Themes.darkColorScheme.background,
          Colors.white,
        ), // Example background color
        titleTextStyle:
            const TextStyle(color: Colors.black), // Example title color
        iconTheme:
            const IconThemeData(color: Colors.black), // Example icon color
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.grey,
        ), // Change the hint text color here
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Widget content = Container(
      color: Themes.getColor(Themes.darkColorScheme.background, Colors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/error-404.png'),
              width: 200,
              height: 200,
            ),
            Text(
              'Not Found',
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
    if (query == '') {
      return Container(
        color: Themes.getColor(Themes.darkColorScheme.background, Colors.white),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  (MediaQuery.of(context).size.height - 50 - 25) / (4 * 240),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: cs_controller.name.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.to(
                    Course(
                      index: index,
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Themes.getColor(
                        Themes.darkColorScheme.primary,
                        Themes.colorScheme.primary,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Themes.getColor(
                      Themes.darkColorScheme.background,
                      Colors.white,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Image.asset(
                          cs_controller.path[index],
                          height: 130,
                          width: 140,
                        ),
                      ),
                      Text(
                        '${cs_controller.name[index]}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${cs_controller.desc[index]}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      FilterDesc = [];
      FilterImages = [];
      Filternames = [];
      Filternames.addAll(cs_controller.name
          .where((element) => element.toLowerCase().startsWith(query))
          .toList());
      Filternames.addAll(cs_controller.name
          .where((element) => element.toUpperCase().startsWith(query))
          .toList());

      for (int i = 0; i < cs_controller.name.length; i++) {
        if (Filternames.contains(cs_controller.name[i])) {
          FilterImages.add(cs_controller.path[i]);
          FilterDesc.add(cs_controller.desc[i]);
        }
      }

      return Filternames.isEmpty
          ? content
          : Container(
              color: Themes.getColor(
                  Themes.darkColorScheme.background, Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 20, bottom: 10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        (MediaQuery.of(context).size.height - 50 - 25) /
                            (4 * 240),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: Filternames.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => Course(
                            index: index,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Themes.getColor(
                              Themes.darkColorScheme.primary,
                              Themes.colorScheme.primary,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Themes.getColor(
                            Themes.darkColorScheme.background,
                            Colors.white,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Image.asset(
                                FilterImages[index],
                                height: 130,
                                width: 140,
                              ),
                            ),
                            Text(
                              '${Filternames[index]}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${FilterDesc[index]}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
    }
  }
}
