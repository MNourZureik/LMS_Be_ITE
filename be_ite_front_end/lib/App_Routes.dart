// ignore_for_file: non_constant_identifier_names, missing_required_param

import 'package:get/get.dart';
import 'package:public_testing_app/src/views/src/AI_Assistant/AI.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/add_quiz_screens/add_quiz_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/add_quiz_screens/multiple_answers_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/add_quiz_screens/quiz_true_or_false_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Doctor_Quizzes/quiz_screens_doctor/quiz_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Student_Quizzes/quiz_solving_screen.dart';
import 'package:public_testing_app/src/views/src/Quizes/Student_Quizzes/quiz_student_screen.dart';
import 'package:public_testing_app/src/views/src/homepage_elements/Drawer_Elements.dart/Saved_Files.dart';
import 'package:public_testing_app/src/views/src/homepage_elements/Drawer_Elements.dart/downloaded_files.dart';
import 'package:public_testing_app/src/views/src/homepage_elements/Drawer_Elements.dart/subject_downloaded_files.dart';
import 'src/middlewares/is_userLogedIn_Middleware.dart';

import 'package:public_testing_app/src/views/auth/change_pass_screens/change_pass_screen.dart';
import 'package:public_testing_app/src/views/auth/log_in_screens/set_pass_screen.dart';
import 'package:public_testing_app/src/views/auth/log_in_screens/email_screen.dart';
import 'package:public_testing_app/src/views/auth/log_in_screens/login_pass_screen.dart';
import 'package:public_testing_app/src/views/auth/log_in_screens/verfication_screen.dart';
import 'package:public_testing_app/src/views/Introduction/IntroductionScreen.dart';
import 'package:public_testing_app/src/views/src/Home/second_Page/subjects.dart';
import 'package:public_testing_app/src/views/src/Home/first_Page/home.dart';
import 'package:public_testing_app/src/views/src/homepage_elements/Drawer_Elements.dart/edit_profile.dart';
import 'package:public_testing_app/src/views/src/Home_Page.dart';

class AppNavigation {
  static String intro = '/IntroductionScreens';
  static String email = '/EmailPageScreen';
  static String login = '/loginPassPageScreen';
  static String register = '/RegisterPassPageScreen';
  static String verify = '/VerificationPageScreen';
  static String homepage = '/StudentHomePageScreen';
  static String reset_pass = '/ChangePassPageScreen';
  static String home = '/Home';
  static String edit_profile = '/EditProfilePageScreen';
  static String subjects = '/SubjectsPageScreen';
  static String AI_Route = '/AI_Route';
  static String Onboard = '/onBoard';
  static String my_subject_types = '/my_subject_types';
  static String quiz = '/quiz';
  static String addQuiz = '/addQuiz';
  static String quiz_true_false = '/quizTrueOrFalse';
  static String quiz_multi_answers = '/multipleAnswers';
  static String saved_files = '/saved_files';
  static String quiz_student = '/quizStudent';
  static String student_download = "/downloaded_files";

  static String get getInitRoute => intro;

  static List<GetPage> routes = [
    GetPage(
      name: intro,
      page: () => const IntroductionScreens(),
      middlewares: [
        isDoctorMiddleware(),
      ],
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: email,
      page: () => const EmailScreen(),
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: verify,
      page: () => const VerificationScreen(),
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: homepage,
      page: () => const HomePage(),
      children: const [],
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: reset_pass,
      page: () => const ChangePassScreen(),
    ),
    GetPage(
      transition: Transition.zoom,
      transitionDuration: const Duration(seconds: 2),
      name: home,
      page: () => const Home(),
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(seconds: 2),
      name: edit_profile,
      page: () => const EditProfile(),
    ),
    GetPage(
      transition: Transition.size,
      transitionDuration: const Duration(seconds: 2),
      name: subjects,
      page: () => Subjects(),
    ),
    GetPage(
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 200),
      name: AI_Route,
      page: () => const AI(),
    ),
    GetPage(
      name: quiz,
      page: () => const QuizScreen(),
    ),
    GetPage(
      name: addQuiz,
      page: () => const AddQuizScreen(),
    ),
    GetPage(
      name: quiz_true_false,
      page: () => const QuizTrueOrFalseScreen(numQuestions: 0),
    ),
    GetPage(
      name: quiz_multi_answers,
      page: () => const MultipleAnswersScreen(numQuestions: 0),
    ),
    GetPage(
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
      name: quiz_student,
      page: () => const QuizStudentScreen(),
    ),
    GetPage(
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
      name: saved_files,
      page: () => const SavedFiles(),
    ),
    GetPage(
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
      name: student_download,
      page: () => const DownloadedFiles(),
    ),
  ];
}
