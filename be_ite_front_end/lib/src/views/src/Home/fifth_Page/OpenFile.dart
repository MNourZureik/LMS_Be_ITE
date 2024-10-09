import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:public_testing_app/src/controllers/Home_Controllers/Home_Controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Openfile extends StatelessWidget {
  const Openfile({super.key, required this.file_path});
  final String file_path;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      body: SfPdfViewer.file(
        File(file_path),
      ),
    );
  }
}
