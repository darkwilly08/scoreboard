import 'package:flutter/material.dart';

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
    return FloatingActionButton(
      heroTag: null,
      elevation: 1.0,
      onPressed: onTap,
      child: Icon(iconData),
    );
  }
}
