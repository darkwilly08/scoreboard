import 'package:anotador/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {Key? key, required Function() this.onTap, required String this.text})
      : super(key: key);

  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    var themeData =
        Provider.of<ThemeController>(context, listen: false).themeData;
    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          primary: themeData.colorScheme.secondary,
        ),
        child: Text(
          text.toUpperCase(),
        ));
  }
}
