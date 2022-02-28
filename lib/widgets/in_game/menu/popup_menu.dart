import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/model/in_game/menu/choice.dart';
import 'package:anotador/widgets/in_game/menu/choice_card.dart';
import 'package:flutter/material.dart';

class InGamePopupMenu extends StatelessWidget {
  const InGamePopupMenu({Key? key, this.callback, this.skip}) : super(key: key);

  final void Function(Choice)? callback;
  final int? skip;

  @override
  Widget build(BuildContext context) {
    int skipCount = skip ?? 0;
    return PopupMenuButton<Choice>(
      onSelected: callback,
      itemBuilder: (BuildContext context) {
        return AppConstants.choices.skip(skipCount).map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: ChoiceCard(choice: choice),
          );
        }).toList();
      },
    );
  }
}
