import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/team.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/custom_text_form_field.dart';
import 'package:anotador/widgets/game_title.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
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
  late int _currentValue;
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

  void handleRemoveLastScoreBtn() {
    setState(() {
      _matchController.removeLatestResult(widget.team);
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
                              icon: const Icon(LineIcons.plus),
                            )
                          : IconButton(
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () {
                                setState(() => _isAddAction = true);
                                sbSetState(() => _isAddAction = true);
                              },
                              icon: const Icon(LineIcons.minus),
                            );
                    }),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: CustomTextFormField(
                            textInputType: TextInputType.number,
                            onChanged: (val) =>
                                _numberField = int.tryParse(val),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                      ),
                    )
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
        GameTitle(title: widget.team.name),
        Expanded(
            child: ListView(
          controller: _scrollController,
          children: widget.team.scoreList.mapIndexed((idx, score) {
            late Widget child;
            if (idx > 0 && idx == widget.team.scoreList.length - 1) {
              final int scoreDiff = (score - widget.team.scoreList[idx - 1]);
              final String diffStr =
                  scoreDiff > 0 ? "(+$scoreDiff)" : "(-${scoreDiff.abs()})";
              child = Column(
                children: [
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      diffStr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: scoreDiff > 0
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.4)
                              : Colors.red.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: handleRemoveLastScoreBtn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Text(
                            score.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: Icon(
                            LineIcons.times,
                            size: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              child = Text(
                score.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w300),
              );
            }

            return FittedBox(
              fit: BoxFit.scaleDown,
              child: child,
            );
          }).toList(),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomFloatingActionButton(
            onTap: () {
              _numberField = null;
              _currentValue = widget.team.match?.game.npMinVal ?? 0;
              _isAddAction = true;
              _showMessageDialog(context);
            },
            iconData: LineIcons.plus,
          ),
        )
      ],
    );
  }
}
