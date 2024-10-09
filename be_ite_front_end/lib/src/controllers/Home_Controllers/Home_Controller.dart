// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, camel_case_types, missing_required_param, unused_catch_clause, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/models/SnackBar.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/api.dart';
import 'package:public_testing_app/src/views/src/Home/fifth_Page/Files.dart';
import 'package:public_testing_app/src/views/src/Home/fourth_Page/FilesTypes.dart';
import 'package:public_testing_app/src/views/src/Home/second_Page/subjects.dart';
import '../../views/src/Home/third_Page/subjectType.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  //? Saved Files Lists :
  List<Map<String, dynamic>> savedFiles_information = [];
  List<bool> isStudentSavedFiles = [];
  List<int> saved_files_ids = [];
  List<String> saved_files_paths = [];

  //? Data for Viewing page :
  ScrollController scrollController = ScrollController();
  List<String> years = ['First Year', 'Second Year', 'Third Year'];
  List<String> photo_paths_of_years = [
    'assets/images/data-scientist.png',
    'assets/images/engineer.png',
    'assets/images/coordinator.png'
  ];
  List<String> numbers_of_years = ['1.', '2.', '3.'];
  String SelectedChoice = 'TP';

  //? THeoritical SUBJECTS and DOCTORS  names :
  List<String> name_of_th_subjects = [];
  List<List<dynamic>> doctors_theoritical = [];
  List<int> subjects_theoritical_ids = [];
  List<int> subjects_practical_ids = [];
  List<bool> isAdded_theoritical = [];

  //? Practical SUBJECTS and DOCTORS  names :
  List<String> name_of_pr_subjects = [];
  List<String> doctor_practical = [];

  //? circle indicaters :
  Widget? circleViewSubject;
  Widget? circleViewFilesTypes;

  //? Files Types Variebles :
  List<String> files_types_photos = [
    'assets/images/ringing.png',
    'assets/images/gallery.png',
    'assets/images/file.png',
  ];
  List<String> files_types_names = [
    'Notifications',
    'Images',
    'Pdf`s',
  ];

  //? variables for fifth page :
  List<String> files_names = [];
  Widget? circle_for_files;
  List<bool> is_added_to_saved_files = [];
  Files_Types ctrl_type = Files_Types.adds;
  Widget? download_circle;
  List<int> files_ids = [];
  List<String> files_paths = [];
  File? files_content;
  double _progress = 0;
  late Timer _timer;
  RxInt start_timer = 4.obs;
  List<dynamic> notifications_ids = [];
  List<bool> is_colapse = [];

  // this function for fetching the subjects :
  void viewSubjectsOfTheYear(int yearNumber) async {
    // UPDATE the button to CircularProgressIndicator while fetching data :
    circleViewSubject = const SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
    update(["viewSubject"]);

    //! send request to server for fetching Theoritical Subjects :
    try {
      final decodedResponse =
          await Api.get_request("year-subjects-theoretical/$yearNumber");
      if (decodedResponse["status"] == 200) {
        List<dynamic> TheoriticalSubjects = decodedResponse["data"];

        // IF the response status are correct we will save the subjects names and its doctors :

        name_of_th_subjects = [];
        doctors_theoritical = [];
        isAdded_theoritical = [];
        subjects_theoritical_ids = [];

        for (int i = 0; i < TheoriticalSubjects.length; i++) {
          final Map<String, dynamic> TH_S = TheoriticalSubjects[i];

          TH_S.forEach(
            (key, value) {
              if (key == "name") {
                name_of_th_subjects.add(value);
                isAdded_theoritical.add(false);
              } else if (key == "doctors") {
                doctors_theoritical.add(value);
              } else if (key == "id") {
                subjects_theoritical_ids.add(value);
              }
            },
          );
        }
        // FETCHING student subjects :
        fetch_Student_Subjects_For_Checking();
      } else {
        Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }
    //! send request to server for fetching Practical Subjects :
    try {
      final decodedResponse =
          await Api.get_request("year-subjects-practical/$yearNumber");
      List<dynamic> PracticalSubjects = decodedResponse["data"];

      // IF the response status are correct we will save the subjects names and its teachers :
      if (decodedResponse["status"] == 200) {
        name_of_pr_subjects = [];
        doctor_practical = [];
        subjects_practical_ids = [];
        for (int i = 0; i < PracticalSubjects.length; i++) {
          final Map<String, dynamic> PR_S = PracticalSubjects[i];

          PR_S.forEach(
            (key, value) {
              if (key == "name") {
                name_of_pr_subjects.add(value);
              } else if (key == "teacher") {
                if (value == null) {
                  doctor_practical.add('');
                } else {
                  doctor_practical.add(value);
                }
              } else if (key == "id") {
                subjects_practical_ids.add(value);
              }
            },
          );
        }
      } else {
        Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }

    //disActive the circle cause the response are proccessed successfuly :
    circleViewSubject = null;
    update(["viewSubject"]);
    // go to the subjects screen and passing subjects to it :
    Get.to(
      () => Subjects.subject(
        id: yearNumber,
        subjects: name_of_th_subjects,
        years: years,
        Subjects_ids: subjects_theoritical_ids,
      ),
    );
    //? save theoritical subjects :
    appData!
        .setStringList('Subjects_Of_The_Year_Theoritical', name_of_th_subjects);
    //? save theoritical subjects :
    appData!
        .setStringList('Subjects_Of_The_Year_Practical', name_of_pr_subjects);

    for (int i = 0; i < name_of_th_subjects.length; i++) {
      if (!name_of_pr_subjects.contains(name_of_th_subjects[i])) {
        subjects_practical_ids.insert(i, 0);
        name_of_pr_subjects.insert(i, ' ');
      }
    }
  }

  // this function for adding the subjects choosed from student to be hisSubjects :
  void addToMySubjects(int subject_id, int index) async {
    //! sending request :
    try {
      final data = {
        "subject_id": '$subject_id',
      };
      final decodedResponse =
          await Api.post_request_with_token("add-to-my-subjects", data);
      //? subject added successfully :
      if (decodedResponse["status"] == 200) {
        isAdded_theoritical[index] = true;
        update(["add_reomve_subject"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // this function for removing the subjects choosed from student to be hisSubjects :
  void removeFromMySubjects(int subject_id, int index) async {
    try {
      final data = {
        "subject_id": '$subject_id',
      };
      final decodedResponse =
          await Api.post_request_with_token("remove-from-my-subjects", data);
      //? subject added successfully :
      if (decodedResponse["status"] == 200) {
        isAdded_theoritical[index] = false;
        update(["add_reomve_subject"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // this function for viewing the theoritical part of the subject and practical part if it is exist :
  void viewSubjectTypes(int index, String subject, int year) {
    final sub_just_th = doctors_theoritical.length - doctor_practical.length;

    String teacher = '';
    List<dynamic> doctors = [];
    for (int i = 0; i < name_of_th_subjects.length; i++) {
      if (subject == name_of_th_subjects[i]) {
        for (int j = 0; j < doctors_theoritical.length; j++) {
          if (j == i) {
            doctors = doctors_theoritical[j];
            break;
          }
        }
        for (int j = 0; j < doctor_practical.length; j++) {
          if (j == (i - sub_just_th)) {
            teacher = doctor_practical[j];
            break;
          }
        }
        break;
      }
    }
    Get.to(
      () => Subjecttype(
        year: year,
        index: index + 1,
        subjectName: subject,
        teacher: teacher,
        doctors: doctors,
      ),
    );
  }

  // this function to check if the subjects has practical part or not :
  bool isHasPractical(String subjectName) {
    List<String> Practicals =
        appData!.getStringList('Subjects_Of_The_Year_Practical')!;
    if (Practicals.contains(subjectName)) {
      return true;
    }
    return false;
  }

  // this function for viewing fileTypes for the speciefic part of the subject :
  void viewFilesTypes(String type, String subject_name, int year, int? index) {
    Get.to(() => Filestypes(
          index: index,
          year: year,
          subject_type: type,
          subject_name: subject_name,
        ));
  }

  // this function for auto scrolling for years cards in home :
  void listenToScrollMoment() {
    if (appData!.getString("connection_result") !=
        "[ConnectivityResult.none]") {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 3 * 10),
            curve: Curves.linear,
          );
        },
      );
    }
  }

  // fetch student subjects :
  void fetch_Student_Subjects_For_Checking() async {
    try {
      final decodedResponse =
          await Api.get_request("student-subjects-theoretical");
      if (decodedResponse['status'] == 200) {
        final List<dynamic> studentSubjects = decodedResponse["data"];
        for (int i = 0; i < studentSubjects.length; i++) {
          final Map<String, dynamic> student_subject = studentSubjects[i];

          for (int j = 0; j < name_of_th_subjects.length; j++) {
            if (name_of_th_subjects[j] == student_subject["name_subject"]) {
              isAdded_theoritical[j] = true;
              update(["add_reomve_subject"]);
            }
          }
        }
      } else {
        log("error");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // viewing bottom sheet for adding subjects :
  Future dialog_for_adding_subject_to_MySubjects(
      BuildContext context, int subject_id, int index) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation_1, animation_2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, widget) {
        return ShowDialog(subject_id, index, a1, a2);
      },
    );
  }

  // bottom Sheet to choose image source : (Gallery || Camera): //? not done :
  Widget ShowDialog(
      int subject_id, int index, Animation<double> a1, Animation<double> a2) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: AlertDialog(
          backgroundColor: Themes.getColor(
              Themes.darkColorScheme.primaryContainer,
              Themes.colorScheme.primaryContainer),
          content: SizedBox(
            width: Get.size.width - 100,
            height: Get.size.width - 180,
            child: GetBuilder<HomeController>(
              id: 'add_TP_or_T',
              builder: (controller) {
                return Stack(
                  children: [
                    // title :
                    Text(
                      'add to My Subjects :',
                      style: Get.textTheme.titleLarge!.copyWith(fontSize: 25),
                    ),
                    // TP :
                    Positioned(
                      top: 55,
                      child: RadioMenuButton(
                        value: 'TP',
                        groupValue: SelectedChoice,
                        onChanged: (value) {
                          SelectedChoice = value!;
                          update(['add_TP_or_T']);
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Themes.getColor(
                                Themes.darkColorScheme.primaryContainer,
                                Themes.colorScheme.primaryContainer),
                          ),
                        ),
                        child: Text(
                          'Theoritical and Practical.',
                          style:
                              Get.textTheme.titleLarge!.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                    // P :
                    Positioned(
                      top: 110,
                      child: RadioMenuButton(
                        value: 'T',
                        groupValue: SelectedChoice,
                        onChanged: (value) {
                          SelectedChoice = value!;
                          update(['add_TP_or_T']);
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Themes.getColor(
                                Themes.darkColorScheme.primaryContainer,
                                Themes.colorScheme.primaryContainer),
                          ),
                        ),
                        child: Text(
                          'Theoritical.',
                          style:
                              Get.textTheme.titleLarge!.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                    // add button :
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 2,
                              offset: Offset(0, 0.5),
                            )
                          ],
                          color: Themes.colorScheme.onPrimaryContainer
                              .withOpacity(.8),
                          border: Border.all(
                            width: 2,
                            color: is_Dark!.getString('is_dark') == 'true'
                                ? Themes.darkColorScheme.primary
                                : Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: Get.size.width / 5,
                        height: Get.size.height / 19,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              if (SelectedChoice == "T") {
                                addToMySubjects(subject_id, index);
                                Get.back();
                              } else if (SelectedChoice == "TP") {
                                int sub_id = subjects_practical_ids[index];
                                addToMySubjects(sub_id, index);
                                Get.back();
                              }
                            },
                            child: Text(
                              'add',
                              style: Get.textTheme.titleLarge!
                                  .copyWith(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // cancel button :
                    Positioned(
                      bottom: 0,
                      right: 90,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 2,
                              offset: Offset(0, 0.5),
                            )
                          ],
                          color: Themes.colorScheme.onPrimaryContainer
                              .withOpacity(.8),
                          border: Border.all(
                            width: 2,
                            color: is_Dark!.getString('is_dark') == 'true'
                                ? Themes.darkColorScheme.primary
                                : Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: Get.size.width / 5,
                        height: Get.size.height / 19,
                        child: Center(
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: Text(
                              'cancel',
                              style: Get.textTheme.titleLarge!
                                  .copyWith(fontSize: 17, color: Colors.white),
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
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  //? Fourth and Fifth Pages Functions:
  // finally done :
  void get_files_names_for_type(
      Files_Types type,
      String subject_type,
      String subject_name,
      int year,
      int? subject_id,
      bool isDoctor,
      File? file,
      int? student_subject_id) async {
    int? id;
    files_ids = [];
    files_names = [];
    is_added_to_saved_files = [];
    files_paths = [];

    ctrl_type = type;

    circle_for_files = const CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
    );
    update(["go_to_files"]);
    if (Auth!.getString("user") == "active_student") {
      if (appData!.getBool("is_my_subjects") == false) {
        if (subject_type == "Theoritical") {
          int i = name_of_th_subjects.indexOf(subject_name);
          id = subjects_theoritical_ids[i];
        } else if (subject_type == "Practical") {
          int i = name_of_pr_subjects.indexOf(subject_name);
          id = subjects_practical_ids[i];
        }
      } else {
        id = student_subject_id;
      }
    } else {
      id = subject_id;
    }
    try {
      final data = {
        "year_id": "$year",
        "subject_id": "$id",
        "file_type": "$ctrl_type".substring(12),
      };
      final decodedResponse =
          await Api.post_request_with_token("get-files-names", data);
      if (decodedResponse["status"] == 200) {
        for (int i = 0; i < decodedResponse["data"].length; i++) {
          Map<String, dynamic> FN = decodedResponse["data"][i];
          is_added_to_saved_files.add(false);

          FN.forEach(
            (key, value) {
              if (key == "id") {
                files_ids.add(value);
              } else if (key == "file_name") {
                files_names.add(value);
              } else if (key == "file_path") {
                files_paths.add(value);
              }
            },
          );
        }
        log(files_ids.toString());
      }
      circle_for_files = null;
      update(["go_to_files"]);
    } catch (e) {
      log(e.toString());
    }

    if (isDoctor) {
      try {
        if (type.name == "pdf") {
          appData!
              .setString("file[${type.name}][${files_ids.last}]", file!.path);
        } else if (type.name == "image") {
          appData!.setString("photo[${files_ids.last}]", file!.path);
        }

        update(["doctor_upload"]);
      } catch (e) {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
      }
    } else {
      getSavedFiles();

      Get.to(
        () => Files(
          type: type,
          subject_name: subject_name,
          year: year,
          subject_type: subject_type,
          subject_id: subject_id,
        ),
      );
    }
  }

  // get student saved Files :
  void getSavedFiles() async {
    try {
      final decodedResponse = await Api.get_request("student-files");
      for (int i = 0; i < decodedResponse["data"].length; i++) {
        final Map<String, dynamic> SF = decodedResponse["data"][i];
        SF.forEach(
          (key, value) {
            if (key == "id") {
              bool isSaved = files_ids.contains(value);
              if (isSaved) {
                int index = files_ids.indexOf(value);
                is_added_to_saved_files[index] = true;
              }
            }
          },
        );
      }
      update(['saved_files']);
    } catch (e) {
      e.toString();
    }
  }

  // finally done :
  void add_to_saved_files(int id, int index) async {
    //! sending file to server :
    is_added_to_saved_files[index] = true;
    update(['saved_files']);

    try {
      final data = {
        "file_id": "$id",
      };
      final decodedResponse =
          await Api.post_request_with_token("add-to-my-files", data);
    } catch (e) {
      e.toString();
    }
  }

  // finally doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee :
  void download_file(
      int index, String type, String subject, String name) async {
    try {
      download_circle = GetBuilder<HomeController>(
        id: 'download_file',
        builder: (controller) {
          return Center(
              child: Text(
            '$_progress %',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ));
        },
      );
      update(['download[$index]']);

      if (appData!.getString("connection_result") !=
          "[ConnectivityResult.none]") {
        files_content = await FileDownloader.downloadFile(
          url: "${Api.public_url}/${files_paths[index]}",
          name: files_paths[index].substring(10).replaceAll(' ', ''),
          subPath: "files/$type",
          onProgress: (String? fileName, double progress) {
            _progress = progress;
            update(['download_file']);
            log('FILE fileName HAS PROGRESS $progress');
          },
          onDownloadCompleted: (String path) {
            _progress = 0;
            log('FILE DOWNLOADED TO PATH: $path');
            FileDownloader.cancelDownload;
          },
          onDownloadError: (String error) {
            download_circle = null;
            FileDownloader.cancelDownload;
            update(["download[$index]"]);
            Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
          },
        );
      } else {
        download_circle = null;
        update(["download[$index]"]);
        if (!Get.isSnackbarOpen) {
          Themes.no_internet_connection();
        }
        return;
      }

      download_circle = null;
      if (files_content != null) {
        final subjects = appData!.getStringList("subjects");
        if (!subjects!.contains(subject)) {
          subjects.add(subject);
          appData!.setStringList("subjects", subjects);
          appData!.setStringList("files[$subject]", []);
          appData!.setStringList("names[$subject]", []);

          final files_paths_of_subject =
              appData!.getStringList("files[$subject]");
          files_paths_of_subject!.add(files_content!.path);
          appData!.setStringList("files[$subject]", files_paths_of_subject);

          final names_paths_of_subject =
              appData!.getStringList("names[$subject]");
          names_paths_of_subject!.add(name);
          appData!.setStringList("names[$subject]", names_paths_of_subject);
        } else {
          final files_paths_of_subject =
              appData!.getStringList("files[$subject]");
          files_paths_of_subject!.add(files_content!.path);
          appData!.setStringList("files[$subject]", files_paths_of_subject);

          final names_paths_of_subject =
              appData!.getStringList("names[$subject]");
          names_paths_of_subject!.add(name);
          appData!.setStringList("names[$subject]", names_paths_of_subject);
        }

        appData!
            .setString("file[$type][${files_ids[index]}]", files_content!.path);
        FileDownloader.cancelDownload;
      }
      update(["download[$index]"]);
    } on PlatformException catch (e) {
      Themes.no_internet_connection();

      download_circle = null;
      update(["download[$index]"]);
      FileDownloader.cancelDownload;
    } catch (e) {
      Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');

      download_circle = null;
      update(["download[$index]"]);
      FileDownloader.cancelDownload;
      log(e.toString());
    }
  }

  // download image Finally Doneeeeeeeeeeeeeeeeeee :
  void download_image(int index) async {
    try {
      download_circle = GetBuilder<HomeController>(
          id: 'circle_in',
          builder: (controller) {
            return CircularProgressIndicator(
              value: _progress,
              color: Colors.black,
              strokeWidth: 2,
            );
          });
      update(['is_image_downloaded[$index]']);
      if (appData!.getString("connection_result") !=
          "[ConnectivityResult.none]") {
        files_content = await FileDownloader.downloadFile(
          url: "${Api.public_url}/${files_paths[index]}",
          name: files_paths[index].substring(12).replaceAll(' ', ''),
          subPath: "files/images",
          onProgress: (String? fileName, double progress) {
            _progress = progress / 100;
            update(['circle_in']);
            log('FILE fileName HAS PROGRESS $progress');
          },
          onDownloadCompleted: (String path) {
            _progress = 0;
            log('FILE DOWNLOADED TO PATH: $path');
            FileDownloader.cancelDownload;
          },
          onDownloadError: (String error) {
            FileDownloader.cancelDownload;
            download_circle = null;
            update(["download_image[$index]"]);
            Themes.no_internet_connection();
          },
        ).timeout(const Duration(minutes: 2));
      } else {
        download_circle = null;
        FileDownloader.cancelDownload;
        update(["download_image[$index]"]);
        if (!Get.isSnackbarOpen) {
          Themes.no_internet_connection();
        }

        return;
      }
      download_circle = null;
      if (files_content != null) {
        appData!.setString("photo[${files_ids[index]}]", files_content!.path);
      }
      update(["download_image[$index]"]);
      files_content = null;
    } catch (e) {
      log(e.toString());
      FileDownloader.cancelDownload;
    }
  }

  //? Saved Files Section Functions :

  void download_saved_file(int index, String type) async {
    try {
      download_circle = GetBuilder<HomeController>(
        id: 'download_file',
        builder: (controller) {
          return Center(
              child: Text(
            '$_progress %',
            style: const TextStyle(color: Colors.white),
          ));
        },
      );
      update(['saved_files_download[$index]']);

      if (appData!.getString("connection_result") !=
          "[ConnectivityResult.none]") {
        files_content = await FileDownloader.downloadFile(
          url: "${Api.public_url}/${saved_files_paths[index]}",
          name: saved_files_paths[index].substring(10).replaceAll(' ', ''),
          subPath: "files/$type",
          onProgress: (String? fileName, double progress) {
            _progress = progress;
            update(['download_file']);
            log('FILE fileName HAS PROGRESS $progress');
          },
          onDownloadCompleted: (String path) {
            _progress = 0;
            log('FILE DOWNLOADED TO PATH: $path');
            FileDownloader.cancelDownload;
          },
          onDownloadError: (String error) {
            download_circle = null;
            FileDownloader.cancelDownload;
            update(["saved_files_download[$index]"]);
            Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
          },
        ).timeout(const Duration(minutes: 5));
      } else {
        download_circle = null;
        FileDownloader.cancelDownload;
        update(["saved_files_download[$index]"]);
        if (!Get.isSnackbarOpen) {
          Themes.no_internet_connection();
        }
        return;
      }

      download_circle = null;
      if (files_content != null) {
        appData!.setString(
            "file[$type][${saved_files_ids[index]}]", files_content!.path);
        FileDownloader.cancelDownload;
      }
      update(["saved_files_download[$index]"]);
    } on PlatformException catch (e) {
      Themes.no_internet_connection();

      download_circle = null;
      update(["saved_files_download[$index]"]);
      FileDownloader.cancelDownload;
    } catch (e) {
      Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
      download_circle = null;
      update(["saved_files_download[$index]"]);
      FileDownloader.cancelDownload;
      log(e.toString());
    }
  }

  void getStudentSavedFiles() async {
    try {
      final decodedResponse = await Api.get_request("student-files");
      if (decodedResponse["status"] == 200) {
        savedFiles_information = [];
        isStudentSavedFiles = [];
        saved_files_ids = [];
        for (int i = 0; i < decodedResponse["data"].length; i++) {
          final Map<String, dynamic> SF = decodedResponse["data"][i];
          savedFiles_information.add(SF);
          isStudentSavedFiles.add(true);
          saved_files_ids.add(SF["id"]);
          saved_files_paths.add(SF["file_path"]);
        }
        update(["student_saved_files"]);
      }
    } catch (e) {
      e.toString();
    }
  }

  void remove_from_saved_files(int file_id, int index) async {
    try {
      final data = {
        "file_id": "$file_id",
      };
      final decodedResponse =
          await Api.post_request_with_token("remove-from-my-files", data);
      if (decodedResponse["status"] == 200) {
        isStudentSavedFiles.removeAt(index);
        saved_files_ids.remove(saved_files_ids[index]);
        update(["student_saved_files"]);
      }
    } catch (e) {
      e.toString();
    }
  }

  void remove_saved_file(BuildContext context, int file_id) async {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    try {
      final index = saved_files_ids.indexOf(file_id);

      Map<String, dynamic> temp = savedFiles_information[index];

      savedFiles_information.remove(savedFiles_information[index]);
      update(['student_saved_files']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: GetX<HomeController>(
            builder: (controller) {
              return Row(
                children: [
                  const Text('file Deleted'),
                  const SizedBox(width: 20),
                  Text('$start_timer'),
                ],
              );
            },
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              _timer.cancel();
              start_timer = 4.obs;
              savedFiles_information.insert(index, temp);
              update(['student_saved_files']);
              return;
            },
          ),
        ),
      );
    } catch (e) {
      Themes.get_notification_info('cross', 'SomeThing Went', 'Wrong !');
    }

    //sending http request to server to remove the subject :
  }

  void update_timer(int file_id, int index) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start_timer == 0.obs) {
          remove_from_saved_files(file_id, index);
          start_timer = 4.obs;
          timer.cancel();
        } else {
          start_timer--;
        }
      },
    );
  }

  //? Recent files :
  void add_to_recent_files(String name, String path) {
    appData!.setBool("not_empty_recent_files", true);
    // set file name to recent file :
    List<String> file_names = appData!.getStringList("recent_files_names")!;
    file_names.addIf(!file_names.contains(name), name);
    appData!.setStringList("recent_files_names", file_names);

    // set file path to recent file :
    List<String> file_paths = appData!.getStringList("recent_files_paths")!;
    file_paths.addIf(!file_paths.contains(path), path);
    appData!.setStringList("recent_files_paths", file_paths);

    update(['recent_files']);
  }

  void remove_from_recent_files(String name, String path) {
    // set file name to recent file :
    List<String> file_names = appData!.getStringList("recent_files_names")!;
    file_names.remove(name);
    appData!.setStringList("recent_files_names", file_names);

    // set file path to recent file :
    List<String> file_paths = appData!.getStringList("recent_files_paths")!;
    file_paths.remove(path);
    appData!.setStringList("recent_files_paths", file_paths);

    if (file_paths.isEmpty) {
      appData!.setBool("not_empty_recent_files", false);
    }
    // view recent file :
    update(['recent_files']);
  }

  @override
  void onInit() async {
    if (Auth!.getString("user") == "active_student") {
      appData!.setBool("is_my_subjects", false);
      appData!.setBool('isSeeAll', false);
      listenToScrollMoment();
      if (appData!.getStringList("recent_files_paths") == null) {
        appData!.setStringList("recent_files_paths", []);
        appData!.setStringList("recent_files_names", []);
        appData!.setBool("not_empty_recent_files", false);
      }
      appData!.setStringList("subjects", []);
    }

    super.onInit();
  }

  void get_notifications(int id, Files_Types? type, String? subject_name,
      int? year, String? subject_type) async {
    dynamic noti;
    try {
      noti = await Api.get_request("get-notifications-subject/$id");

      if (noti["status"] == 200) {
        notifications_ids = noti["data"];
        update(["doctor_upload"]);
        for (int i = 0; i < notifications_ids.length; i++) {
          is_colapse.add(false);
        }
        if (type != null &&
            subject_name != null &&
            year != null &&
            subject_type != null) {
          Get.to(
            () => Files(
              type: type,
              subject_name: subject_name,
              year: year,
              subject_type: subject_type,
              subject_id: id,
            ),
          );
        }
      } else {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void delete_notification(int id) async {
    dynamic noti;
    try {
      noti = await Api.get_request("delete-notifications-subject/$id");
      if (noti["status"] == 200) {
        Themes.get_notification_info(
            "check", "Notification Deleted", "Successfully");
        update(["doctor_upload"]);
      } else {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void delete_file(int file_id, int index, Files_Types type) async {
    try {
      final response = await Api.get_request("delete_file/$file_id");
      if (response["status"] == 200) {
        Themes.get_notification_info("check", "file deleted", "successfully");

        if (type.name == "pdf") {
          appData!.setString("file[${type.name}][${files_ids[index]}]", '');
        } else if (type.name == "image") {
          appData!.setString("photo[${files_ids[index]}]", '');
        }
        files_ids.removeAt(index);
        files_names.removeAt(index);
        files_paths.removeAt(index);
        update(["doctor_upload"]);
      } else {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
