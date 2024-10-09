// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:public_testing_app/src/models/Themes.dart';


class CustomShapeTop extends StatelessWidget {
  const CustomShapeTop({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RPSCustomPainter(),
      child: SizedBox(
        width: Themes.getWidth(context),
        height: Themes.getHeight(context) / 4.5,
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Triangle

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    paint_fill_1.shader = ui.Gradient.linear(
        Offset(size.width * 0.25, size.height * -0.00),
        Offset(size.width * 0.25, size.height * 0.86), [
      Themes.getColor(
          Themes.darkColorScheme.primary, Themes.colorScheme.primary),
      const Color(0xffffffff)
    ], [
      0.00,
      1.00
    ]);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5006417, size.height * -0.0007429);
    path_1.quadraticBezierTo(size.width * 0.1269083, size.height * -0.0003429,
        size.width * 0.0003083, size.height * -0.0007429);
    path_1.quadraticBezierTo(size.width * -0.0015750, size.height * 0.2137571,
        size.width * 0.0000417, size.height * 0.8564000);
    path_1.cubicTo(
        size.width * -0.0014750,
        size.height * 0.4256571,
        size.width * 0.0842333,
        size.height * 0.0008571,
        size.width * 0.5006417,
        size.height * -0.0007429);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);

    // Triangle Copy

    Paint paint_fill_2 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    paint_fill_2.shader = ui.Gradient.linear(Offset(size.width * 0.75, 0),
        Offset(size.width * 0.75, size.height * 0.86), [
      Themes.getColor(
          Themes.darkColorScheme.primary, Themes.colorScheme.primary),
      const Color(0xffffffff)
    ], [
      0.00,
      1.00
    ]);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.4986667, 0);
    path_2.quadraticBezierTo(
        size.width * 0.8754000, size.height * 0.0004000, size.width, 0);
    path_2.quadraticBezierTo(size.width * 1.0012833, size.height * 0.2145000,
        size.width * 0.9996667, size.height * 0.8571429);
    path_2.cubicTo(
        size.width * 1.0011833,
        size.height * 0.4264000,
        size.width * 0.9160750,
        size.height * 0.0004571,
        size.width * 0.4986667,
        0);
    path_2.close();

    canvas.drawPath(path_2, paint_fill_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
