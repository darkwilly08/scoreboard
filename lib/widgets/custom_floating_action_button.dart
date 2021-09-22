import 'package:anotador/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {Key? key,
      required Function() this.onTap,
      required IconData this.iconData})
      : super(key: key);

  final Function() onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    var themeData =
        Provider.of<ThemeController>(context, listen: false).themeData;
    return FloatingActionButton(
      heroTag: null,
      elevation: 1.0,
      backgroundColor: themeData.colorScheme.primary,
      onPressed: onTap,
      child: Icon(iconData, color: themeData.colorScheme.secondary),
    );
  }
}
