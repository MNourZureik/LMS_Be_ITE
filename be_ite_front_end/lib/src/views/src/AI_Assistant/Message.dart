import 'package:flutter/material.dart';

class Message {
  final Widget? loading;
  final String text;
  final bool isUser;
  Message({this.loading, required this.text, required this.isUser});
}
