import 'package:flutter/material.dart';

class BoxTile extends StatelessWidget {
  final Widget child;
  const BoxTile({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
      child: Center(child: child),
    );
  }
}
