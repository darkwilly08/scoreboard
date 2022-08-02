import 'package:anotador/model/in_game/menu/choice.dart';
import 'package:anotador/utils/localization_helper.dart';
import 'package:flutter/material.dart';

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, required this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    // final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            choice.icon,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(LocalizationHelper.of(context).get(choice.title)),
          const Divider()
        ],
      ),
    );
  }
}
