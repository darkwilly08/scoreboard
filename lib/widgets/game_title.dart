import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const GameTitle({Key? key, required this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
