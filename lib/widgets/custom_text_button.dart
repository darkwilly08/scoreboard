import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        child: Text(
          text.toUpperCase(),
        ));
  }
}
