import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/OtherUsers_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';
import 'package:public_testing_app/src/models/api.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/add_quiz_screens/multiple_answers_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/add_quiz_screens/quiz_true_or_false_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Student_Quizzes/quiz_result_screen.dart';

class QuizController extends GetxController {
  List<Map<String, dynamic>> quizzes = [];
  Map<int, int?> selected_answers = {};
  List<bool> completed_quizzes = [];
  RxString time = '00:00'.obs;
  int remainingSeconds = 1;
  RxInt start_timer = 4.obs;
  Timer? My_timer;
  late Timer _timer;

  final form_key = GlobalKey<FormState>();
  final timer_form_key = GlobalKey<FormState>();
  List<GlobalKey<FormState>> form_key_for_true_or_false = [];
  List<GlobalKey<FormState>> form_key_for_multible_question = [];
  List<List<GlobalKey<FormState>>> form_key_for_multible_answers = [];
  final List<String> levels = ['Easy', 'Medium', 'Hard'];

  String selectedSubject = '';
  List<List<dynamic>> student_answers_from_back = [];
  String selectedQuestionType = 'true_or_false';
  String selectedLevel = 'Easy';
  int numQuestion = 3;
  int timer = 5;
  int index = 0;

  List<TextEditingController> questionControllers = [];
  List<List<TextEditingController>> answerControllers = [];
  List<String?> answers = [];
  List<int> answerFieldCounts = [];
  List<int> correctAnswers = [];
  String Selected_Type_Subject = '';
  List<int> quizzes_ids = [];
  List<String> student_answers = [];

  Widget? circle;

  void updateSelectedAnswer(int questionIndex, dynamic value) {
    selected_answers[questionIndex] = value;
    update();
  }

  void startTimer(int seconds, Map<String, dynamic> quiz) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    My_timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (remainingSeconds != -1) {
          int min = remainingSeconds ~/ 60;
          int sec = remainingSeconds % 60;
          time.value =
              '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
          remainingSeconds--;
        } else {
          remainingSeconds = 1;
          time = "00:00".obs;
          timer.cancel();
          My_timer = null;
          Get.off(
            () => QuizResultScreen(
              studentAnswers: selected_answers,
              quiz: quiz,
            ),
          );
        }
      },
    );
  }

  // إضافة اختبار جديد إلى القائمة
  void addQuiz(Map<String, dynamic> quiz) {
    quizzes.add(quiz);
    update();
  }

  // حذف اختبار من القائمة بواسطة الفهرس
  void deleteQuiz(int index, BuildContext context) {
    final temp = quizzes[index];

    quizzes.removeAt(index);
    completed_quizzes[index];
    bool isComplete = completed_quizzes[index];
    completed_quizzes.removeAt(index);
    update();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Quiz Deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            quizzes.insert(index, temp);
            completed_quizzes.insert(index, isComplete);
            update();
            return;
          },
        ),
      ),
    );
  }

  void remove_quiz_from_DB(int quiz_id, int index) async {
    try {
      final decodedResponse = await Api.get_request("delete-quiz/$quiz_id");
      if (decodedResponse["status"] == 200) {
        Themes.get_notification_info('check', 'Quiz Deleted', 'Successfully !');
        update(["quiz_deleted"]);
      }
    } catch (e) {
      e.toString();
    }
  }

  void remove_quiz(BuildContext context, int quiz_id) async {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    try {
      final index = quizzes_ids.indexOf(quiz_id);

      Map<String, dynamic> temp = quizzes[index];

      quizzes.remove(quizzes[index]);
      update(['quizzes']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: GetX<QuizController>(
            builder: (controller) {
              return Row(
                children: [
                  const Text('quiz Deleted'),
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
              quizzes.insert(index, temp);
              update(['quizzes']);
              return;
            },
          ),
        ),
      );
    } catch (e) {
      Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
    }
  }

  void update_timer(int quiz_id, int index) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start_timer == 0.obs) {
          remove_quiz_from_DB(quiz_id, index);
          start_timer = 4.obs;
          timer.cancel();
        } else {
          start_timer--;
        }
      },
    );
  }

  // تابع لتقديم الإجابات والتحقق منها عند الضغط على زر الإرسال
  void submitAnswers(Map<String, dynamic> quiz, int quizIndex) async {
    if (selected_answers.length != quiz['questions'].length) {
      Themes.get_notification_info("cross", "Error!", "Incomplete Answers");
      return;
    }
    student_answers = [];
    remainingSeconds = 1;
    time = "00:00".obs;
    My_timer = null;
    completed_quizzes[quizIndex] = true; // جديد: تعيين حالة الاختبار كمكتمل

    for (int i = 0; i < selected_answers.length; i++) {
      var question_answer =
          quiz["questions"][i]["answers"][selected_answers[i]];

      student_answers.add(question_answer);
    }
    selected_answers = {};
    final data = {
      'quiz_id': '${quizzes_ids[quizIndex]}',
      'answers': student_answers,
    };

    final decodedResponse = await Api.post_request_with_token_using_json(
        "quizzes-solved-by-student", data);

    if (decodedResponse["status"] == 200) {
      Themes.get_notification_info("check", "Quiz Solved", "Successfuly.");
      Get.off(
          () => QuizResultScreen(studentAnswers: selected_answers, quiz: quiz));
    } else {
      Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
    }
  }

  void onSave() {
    if (form_key.currentState!.validate() &&
        timer_form_key.currentState!.validate()) {
      timer_form_key.currentState!.save();
      form_key.currentState!.save();
      if (selectedQuestionType == 'true_or_false') {
        Get.to(
          () => QuizTrueOrFalseScreen(numQuestions: numQuestion),
        );
      } else if (selectedQuestionType == 'multiple_answers') {
        Get.to(
          () => MultipleAnswersScreen(numQuestions: numQuestion),
        );
      }
    }
  }

  void get_other_users_quizes() async {
    try {
      final decodedResponse = await Api.get_request("show-quizzes");
      if (decodedResponse["status"] == 200) {
        final quizzes = decodedResponse["data"];
        for (int i = 0; i < quizzes.length; i++) {
          completed_quizzes.add(false);
          quizzes_ids.add(quizzes[i]["id"]);
          final quiz = quizzes[i];
          addQuiz({
            'subject': quiz["subject"],
            'type': quiz["type"],
            'questions': quiz["questions"],
            'level': quiz["level"],
            'time': quiz["time"],
            'num_question': quiz["num_question"],
          });
        }
      }
    } catch (e) {
      Themes.no_internet_connection();
    }
  }

  void publishQuiz_TrueORFalse(int numQuestions) async {
    for (int index = 0; index < numQuestions; index++) {
      if (form_key_for_true_or_false[index].currentState!.validate()) {
        form_key_for_true_or_false[index].currentState!.save();
      } else {
        return;
      }
    }
    var questions = List.generate(
      numQuestions,
      (i) {
        return {
          'question': questionControllers[i].text,
          'answers': ['True', 'False'],
          'correctAnswer': answers[i] == 'true' ? 0 : 1,
        };
      },
    );

    Map<String, dynamic> subject;
    final OtherusersSubjectsController controller =
        Get.put(OtherusersSubjectsController());
    subject = controller.other_user_subjects_information.firstWhere((element) {
      return element["name_subject"] == selectedSubject;
    });

    try {
      final data = {
        'subject_id': subject["id"],
        'type': 'true_or_false',
        'questions': questions,
        'level': selectedLevel,
        'time': timer.toString(),
        'num_of_questions': numQuestions.toString(),
      };

      circle = const SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
      update(['publish']);

      final decodedResponse =
          await Api.post_request_with_token_using_json("add-quiz", data);

      if (decodedResponse["status"] == 200) {
        quizzes = [];
        quizzes_ids = [];
        get_other_users_quizes();
        Get.back();
        Get.back();
        Themes.get_notification_info(
            "check", "Quiz Published", "Successfully!");
        circle = null;
        update(['publish']);
      } else {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
        circle = null;
        update(['publish']);
      }
    } catch (e) {
      log(e.toString());
    }

    questionControllers =
        List.generate(numQuestions, (_) => TextEditingController());
    answers = List<String?>.filled(numQuestions, null, growable: true);
  }

  void init_num_question(int number) {
    numQuestion = number;
    questionControllers = List.generate(number, (_) => TextEditingController());
    form_key_for_true_or_false =
        List.generate(number, (_) => GlobalKey<FormState>());
    form_key_for_multible_question =
        List.generate(number, (_) => GlobalKey<FormState>());
    form_key_for_multible_answers = List.generate(
        number, (_) => List.generate(2, (_) => GlobalKey<FormState>()));
    answerControllers = List.generate(
        number, (_) => [TextEditingController(), TextEditingController()]);
    answers = List<String?>.filled(number, "false", growable: true);
    answerFieldCounts = List<int>.filled(number, 2, growable: true);
    correctAnswers = List<int>.filled(number, 0, growable: true);
  }

  // تعيين الموضوع المحدد للاختبار
  void setSelectedSubject(String subject) {
    selectedSubject = subject;
    update();
  }

  // تعيين نوع السؤال المحدد للاختبار
  void setSelectedQuestionType(String type) {
    selectedQuestionType = type;
    update();
  }

  // تعيين مستوى الصعوبة المحدد للاختبار
  void setSelectedLevel(String level) {
    selectedLevel = level;
    update();
  }

  void setSelectedTimer(int time) {
    timer = time;
    update();
  }

  // تعيين عدد الأسئلة للاختبار
  void setNumQuestions(int num) {
    numQuestion = num;
    update();
  }

  // تعيين الإجابة لسؤال معين
  void setAnswer(int index, String answer) {
    answers[index] = answer;
    update();
  }

  // تهيئة حقول الإجابات للأسئلة متعددة الخيارات
  void initializeAnswerFields(int numQuestions) {
    numQuestion = numQuestions;
    update(['update_num_question']);
  }

  // إضافة حقل إجابة إضافي لسؤال معين
  void addAnswerField(int index) {
    if (answerFieldCounts[index] < 5) {
      answerFieldCounts[index]++;
      answerControllers[index].add(TextEditingController());
      form_key_for_multible_answers[index].add(GlobalKey<FormState>());
      update(['quiz']);
    }
  }

  void removeAnswerField(int index) {
    if (answerFieldCounts[index] > 1) {
      answerFieldCounts[index]--;
      answerControllers[index].remove(TextEditingController());
      form_key_for_multible_answers[index].remove(GlobalKey<FormState>());
      update(['quiz']);
    }
  }

  // تعيين الإجابة الصحيحة لسؤال معين
  void setCorrectAnswer(int questionIndex, int answerIndex) {
    correctAnswers[questionIndex] = answerIndex;
    update(['quiz']);
  }

  void publishQuiz_MultiAnswers(int numQuestions) async {
    for (int index = 0; index < numQuestions; index++) {
      if (form_key_for_multible_question[index].currentState!.validate()) {
        form_key_for_multible_question[index].currentState!.save();
        for (int j = 0; j < answerFieldCounts[index]; j++) {
          if (form_key_for_multible_answers[index][j]
              .currentState!
              .validate()) {
            form_key_for_multible_answers[index][j].currentState!.save();
          } else {
            return;
          }
        }
      } else {
        return;
      }
    }
    var questions = List.generate(numQuestions, (i) {
      return {
        'question': questionControllers[i].text,
        'answers': List.generate(answerFieldCounts[i], (j) {
          return answerControllers[i][j].text;
        }),
        'correctAnswer': correctAnswers[i],
      };
    });

    Map<String, dynamic> subject;
    final OtherusersSubjectsController controller = Get.find();
    subject = controller.other_user_subjects_information.firstWhere((element) {
      return element["name_subject"] == selectedSubject;
    });

    try {
      final data = {
        'subject_id': subject["id"],
        'type': 'multiple_answers',
        'questions': questions,
        'level': selectedLevel,
        'time': timer.toString(),
        'num_of_questions': numQuestions.toString(),
      };
      circle = const SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
      update(['publish']);
      final decodedResponse =
          await Api.post_request_with_token_using_json("add-quiz", data);
      if (decodedResponse["status"] == 200) {
        quizzes = [];
        quizzes_ids = [];
        get_other_users_quizes();
        Get.back();
        Get.back();
        Themes.get_notification_info(
            "check", "Quiz Published", "Successfully!");
        circle = null;
        update(['publish']);
      } else {
        Themes.get_notification_info("cross", "Something Went", "Wrong!");
        circle = null;
        update(['publish']);
      }
    } catch (e) {
      log(e.toString());
    }
    questionControllers =
        List.generate(numQuestions, (_) => TextEditingController());
    answers = List<String?>.filled(numQuestions, null, growable: true);
  }

  //viewing dialog for choosing subject :
  Future dialog_for_choosing_subject_from_MySubjects(
      BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: Themes.getColor(
          Themes.darkColorScheme.secondaryContainer,
          Themes.colorScheme.primaryContainer),
      context: context,
      builder: (ctx) => BottomSheet(),
    );
  }

  // bottom Sheet to choose image source : (Gallery || Camera): //? not done :
  Widget BottomSheet() {
    return GetBuilder<OtherusersSubjectsController>(
      init: OtherusersSubjectsController(),
      id: 'subject_choosen',
      builder: (controller) {
        double height = 0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // title :
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                child: Text(
                  'Choose Subject :',
                  style: Get.textTheme.titleLarge!.copyWith(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // subjects of Doctors :
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    controller.other_user_subjects_information.length,
                    (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          height: 50,
                          width: Get.size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: RadioMenuButton(
                              value:
                                  controller.other_user_subjects_information[i]
                                      ["name_subject"],
                              groupValue: selectedSubject,
                              onChanged: (value) {
                                selectedSubject = value!;
                                Selected_Type_Subject = controller
                                        .other_user_subjects_information[i]
                                    ["subject_type"];
                                controller.update(["subject_choosen"]);
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
                                '${controller.other_user_subjects_information[i]["name_subject"]}  (${controller.other_user_subjects_information[i]["subject_type"]})',
                                style: Get.textTheme.titleLarge!
                                    .copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            //? buttons :
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 2,
                          offset: Offset(0, 0.5),
                        )
                      ],
                      color:
                          Themes.colorScheme.onPrimaryContainer.withOpacity(.8),
                      border: Border.all(
                        width: 2,
                        color: Themes.getColor(
                            Themes.darkColorScheme.primary, Colors.blue),
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
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 2,
                          offset: Offset(0, 0.5),
                        )
                      ],
                      color:
                          Themes.colorScheme.onPrimaryContainer.withOpacity(.8),
                      border: Border.all(
                        width: 2,
                        color: Themes.getColor(
                            Themes.darkColorScheme.primary, Colors.blue),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: Get.size.width / 5,
                    height: Get.size.height / 19,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          update(["choose_subject"]);
                          Get.back();
                        },
                        child: Text(
                          'choose',
                          style: Get.textTheme.titleLarge!
                              .copyWith(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // get student quizzes :
  void get_student_quizes() async {
    try {
      final decodedResponse =
          await Api.get_request("get-quizzes-for-student-subjects");
      if (decodedResponse["status"] == 200) {
        final quizzes = decodedResponse["data"];
        for (int i = 0; i < quizzes.length; i++) {
          final quiz = quizzes[i];
          if (quiz["is_solved"] == 0) {
            completed_quizzes.add(false);
          } else {
            completed_quizzes.add(true);
          }
          quizzes_ids.add(quiz["id"]);
          addQuiz({
            'student_answers': quiz["student_answers"],
            'subject': quiz["subject"],
            'type': quiz["type"],
            'questions': quiz["questions"],
            'level': quiz["level"],
            'time': quiz["time"],
            'num_question': quiz["num_question"],
          });
        }
      } else {
        Themes.get_notification_info("cross", "SomeThing Went", "Wrong!");
      }
    } catch (e) {
      Themes.no_internet_connection();
    }
  }

  @override
  void onInit() {
    if (Auth!.getString("user") != "active_student") {
      init_num_question(3);
      quizzes = [];
      quizzes_ids = [];
    }
    if (Auth!.getString("user") == "active_student") {
      quizzes = [];
      quizzes_ids = [];
      completed_quizzes = [];
      get_student_quizes();
    }

    super.onInit();
  }
}
