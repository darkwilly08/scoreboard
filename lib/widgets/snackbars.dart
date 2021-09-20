import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar(Widget content)
      : super(content: content, backgroundColor: Colors.greenAccent) {}
}

class DangerSnackBar extends SnackBar {
  DangerSnackBar(Widget content)
      : super(content: content, backgroundColor: Colors.redAccent) {}
}
