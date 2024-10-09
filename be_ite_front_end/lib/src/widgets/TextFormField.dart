// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:public_testing_app/main.dart';
import 'package:public_testing_app/src/models/Themes.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.Text_Position,
    this.Pass_Security,
    this.TextController,
    required this.validate,
    required this.save,
    this.keyboard,
    super.key,
    this.initValue,
  });

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final TextEditingController? TextController;
  final TextInputType? keyboard;
  final String? Function(String? value) validate;
  final void Function(String? value) save;
  final bool? Pass_Security;
  final TextAlign? Text_Position;
  final String? initValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: TextFormField(
        textAlign: Text_Position ?? TextAlign.start,
        obscureText: Pass_Security ?? false,
        controller: TextController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          label: label != null
              ? Text(
                  label!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: MediaQuery.of(context).size.width / 30),
                )
              : null,
          filled: true,
          fillColor: Themes.getColor(Colors.black54, Colors.grey.shade400),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboard,
        validator: validate,
        onSaved: save,
        obscuringCharacter: '*',
        textCapitalization: TextCapitalization.none,
        initialValue: initValue,
      ),
    );
  }
}
