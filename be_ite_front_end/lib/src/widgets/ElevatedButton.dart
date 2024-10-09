// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class MyElevetedButton extends StatelessWidget {
  const MyElevetedButton(
      {super.key,
      this.label,
      required this.onTap,
      required this.width,
      required this.height,
      this.widget,
      required this.BackColor});

  final String? label;
  final void Function() onTap;
  final double width;
  final double height;
  final Widget? widget;
  final Color BackColor;

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      label ?? '',
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: MediaQuery.of(context).size.width / 22,
            color: Colors.white,
          ),
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        backgroundColor: BackColor,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / width,
          vertical: MediaQuery.of(context).size.width / height,
        ),
      ),
      onPressed: onTap,
      child: widget ?? content,
    );
  }
}
