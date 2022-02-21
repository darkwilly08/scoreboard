import 'package:anotador/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
        ),
        child: Text(
          text.toUpperCase(),
        ));
  }
}
