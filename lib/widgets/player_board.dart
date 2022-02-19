import 'dart:ui';

import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class TeamBoard extends StatefulWidget {
  final Team team;
  const TeamBoard({Key? key, required this.team}) : super(key: key);

  @override
  _TeamBoardState createState() => _TeamBoardState();
}

class _TeamBoardState extends State<TeamBoard> {
  late MatchController _matchController;
  final ScrollController _scrollController = ScrollController();
  int? _numberField;
  int _currentValue = 10;
  bool _isAddAction = true;

  @override
  void initState() {
    _matchController = Provider.of<MatchController>(context, listen: false);
    super.initState();
  }

  Future<void> executeAfterBuild() {
    return Future(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void handleAddScoreBtn() {
    Navigator.pop(context);
    int value = _currentValue;
    if (_numberField != null) {
      value = _isAddAction ? _numberField! : -1 * _numberField!;
    }
    setState(() {
      _matchController.addResult(widget.team, value);
    });
  }

  _showMessageDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.only(top: 8.0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          title: Text(widget.team.name),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    StatefulBuilder(builder: (context, sbSetState) {
                      return _isAddAction
                          ? IconButton(
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () {
                                setState(() => _isAddAction = false);
                                sbSetState(() => _isAddAction = false);
                              },
                              icon: Icon(Icons.add))
                          : IconButton(
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () {
                                setState(() => _isAddAction = true);
                                sbSetState(() => _isAddAction = true);
                              },
                              icon: Icon(Icons.remove));
                    }),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CustomTextFormField(
                          textInputType: TextInputType.number,
                          onChanged: (val) => _numberField = int.tryParse(val),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                    ))
                  ],
                ),
                StatefulBuilder(
                  builder: (context, sbSetState) {
                    if (widget.team.match?.game.npMinVal == null) {
                      return Container();
                    }
                    return NumberPicker(
                        axis: Axis.vertical,
                        value: _currentValue,
                        minValue: widget.team.match!.game.npMinVal!,
                        maxValue: widget.team.match!.game.npMaxVal!,
                        step: widget.team.match!.game.npStep!,
                        onChanged: (value) {
                          setState(() => _currentValue = value);
                          sbSetState(() => _currentValue = value);
                        });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CustomTextButton(
                onTap: handleAddScoreBtn,
                text: AppLocalizations.of(context)!.accept),
            CustomTextButton(
                onTap: () => Navigator.pop(context),
                text: AppLocalizations.of(context)!.cancel),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    executeAfterBuild();
    return Column(
      children: [
        Text(widget.team.name),
        Expanded(
            child: ListView(
          controller: _scrollController,
          children: widget.team.scoreList
              .map((score) => Text(
                    score.toString(),
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        )),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomFloatingActionButton(
              onTap: () {
                _numberField = null;
                _currentValue = widget.team.match?.game.npMinVal ?? 0;
                _isAddAction = true;
                _showMessageDialog(context);
              },
              iconData: Icons.add),
        )
      ],
    );
  }
}
