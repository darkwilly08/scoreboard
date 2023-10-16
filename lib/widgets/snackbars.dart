import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar(String message, {Duration? duration})
      : super(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
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
