import 'package:flutter/material.dart';

class CustomLocale {
  final String languageCode;
  final String languageName;

  const CustomLocale(
      {Key? key, required this.languageCode, required this.languageName});

  @override
  String toString() {
    return languageName;
  }
}
