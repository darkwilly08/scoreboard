import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  const SuccessSnackBar(Widget content)
      : super(
            content: content,
            backgroundColor: Colors.greenAccent,
            duration: const Duration(milliseconds: 1000));
}

class DangerSnackBar extends SnackBar {
  const DangerSnackBar(Widget content)
      : super(
            content: content,
            backgroundColor: Colors.redAccent,
            duration: const Duration(milliseconds: 4000));
}
