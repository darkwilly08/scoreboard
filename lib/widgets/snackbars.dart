import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  const SuccessSnackBar(Widget content, {Duration? duration})
      : super(
            content: content,
            backgroundColor: const Color(0xFF018786),
            duration: duration ?? const Duration(milliseconds: 1000));
}

class DangerSnackBar extends SnackBar {
  const DangerSnackBar(Widget content)
      : super(
            content: content,
            backgroundColor: Colors.redAccent,
            duration: const Duration(milliseconds: 4000));
}
