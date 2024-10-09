import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:public_testing_app/src/controllers/My_Subjects_Controllers/OtherUsers_Subjects_Controller.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class UploadButton extends StatelessWidget {
  const UploadButton(
      {super.key,
      required this.type,
      required this.subject_id,
      required this.subject_type,
      required this.subject_name,
      required this.year});

  final String type;
  final int subject_id;
  final String subject_type;
  final String subject_name;
  final int year;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final OtherusersSubjectsController other_users_controller = Get.find();
    final content = Container(
      width: width / 6,
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
      child: InkWell(
        onTap: () => other_users_controller.upload_files(context,
            type, subject_id, subject_name, subject_type, year),
        child: const Icon(
          size: 35,
          Icons.arrow_circle_up_rounded,
          color: Colors.white,
        ),
      ),
    );
    return content;
  }
}
