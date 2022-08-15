import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/dialogs/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../widgets/back_header.dart';

class GameSettings extends StatefulWidget {
  static const String routeName = '/gameSettings';

  final bool isNew;

  const GameSettings({Key? key, this.isNew = false}) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  late GameController _gameController;
  late Game _selectedGame;
  late bool isNew;

  @override
  void initState() {
    _gameController = Provider.of<GameController>(context, listen: false);
    if (!widget.isNew && _gameController.selectedGame != null) {
      isNew = false;
      _selectedGame = _gameController.selectedGame!;
    } else {
      isNew = true;
      _selectedGame = _gameController.createEmptyGame();
      _gameController.setSelected(_selectedGame);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _GameSettingsPhoneView(this);
  }

  void handleUpdateName(String? gameName) {
    if (gameName != null) {
      if (isNew) {
        _selectedGame.name = gameName;
      } else {
        _gameController.updateGameName(gameName);
      }
    }
  }

  void handleUpdateTargetScore(int? score) {
    if (score != null) {
      if (isNew) {
        _selectedGame.targetScore = score;
      } else {
        _gameController.updateTargetScore(score);
      }
    }
  }

  void handleUpdateTargetScoreWins(bool targetScoreWins) {
    if (isNew) {
      _selectedGame.targetScoreWins = targetScoreWins;
    } else {
      _gameController.updateTargetScoreWins(targetScoreWins);
    }
  }

  void handleUpdateNegativeAllowed(bool negativeAllowed) {
    if (isNew) {
      _selectedGame.isNegativeAllowed = negativeAllowed;
    } else {
      _gameController.updateNegativeAllowed(negativeAllowed);
    }
  }

  void handelSaveBtn() {}
  void handelCancelBtn() {}
}

class _GameSettingsPhoneView
    extends WidgetView<GameSettings, _GameSettingsState> {
  const _GameSettingsPhoneView(_GameSettingsState state, {Key? key})
      : super(state, key: key);

  Widget _buildSetingsList() {
    return Consumer<GameController>(builder: (context, gameController, _) {
      return SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: AppTheme.darkTheme.scaffoldBackgroundColor,
        ),
        lightTheme: SettingsThemeData(
          settingsListBackground: AppTheme.lightTheme.scaffoldBackgroundColor,
        ),
        sections: [
          SettingsSection(
            title: Text(
              AppLocalizations.of(context)!.basic,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(LineIcons.dice),
                title: Text(AppLocalizations.of(context)!.game_name),
                value: Text(state._selectedGame.name),
                onPressed: (BuildContext context) async {
                  String? newGameName = await InputDialog(
                    title: Text(AppLocalizations.of(context)!.game_name),
                    isNumber: false,
                    val: state._selectedGame.name,
                  ).show(context);

                  state.handleUpdateName(newGameName);
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              AppLocalizations.of(context)!.rules,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(LineIcons.flagCheckered),
                title: Text(AppLocalizations.of(context)!.target_score),
                value: Text(state._selectedGame.targetScore.toString()),
                onPressed: (BuildContext context) async {
                  String? valStr = await InputDialog(
                    title: Text(AppLocalizations.of(context)!.target_score),
                    isNumber: true,
                    val: state._selectedGame.targetScore.toString(),
                  ).show(context);

                  int? score = valStr != null ? int.tryParse(valStr) : null;
                  state.handleUpdateTargetScore(score);
                },
              ),
              SettingsTile.switchTile(
                leading: const Icon(LineIcons.trophy),
                onToggle: state.handleUpdateTargetScoreWins,
                initialValue: state._selectedGame.targetScoreWins,
                title: Text(AppLocalizations.of(context)!.target_score_wins),
              ),
              SettingsTile.switchTile(
                leading: const Icon(LineIcons.minusCircle),
                onToggle: state.handleUpdateNegativeAllowed,
                initialValue: state._selectedGame.isNegativeAllowed,
                title: Text(AppLocalizations.of(context)!.is_negative_allowed),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              "Popup Selector",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(LineIcons.flagCheckered),
                title: Text("Min"),
                value: Text(state._selectedGame.targetScore.toString()),
                onPressed: (BuildContext context) async {
                  String? valStr = await InputDialog(
                    title: Text(AppLocalizations.of(context)!.target_score),
                    isNumber: true,
                    val: state._selectedGame.targetScore.toString(),
                  ).show(context);

                  int? score = valStr != null ? int.tryParse(valStr) : null;
                  state.handleUpdateTargetScore(score);
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(LineIcons.flagCheckered),
                title: Text("Max"),
                value: Text(state._selectedGame.targetScore.toString()),
                onPressed: (BuildContext context) async {
                  String? valStr = await InputDialog(
                    title: Text(AppLocalizations.of(context)!.target_score),
                    isNumber: true,
                    val: state._selectedGame.targetScore.toString(),
                  ).show(context);

                  int? score = valStr != null ? int.tryParse(valStr) : null;
                  state.handleUpdateTargetScore(score);
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(LineIcons.flagCheckered),
                title: Text("Step"),
                value: Text(state._selectedGame.targetScore.toString()),
                onPressed: (BuildContext context) async {
                  String? valStr = await InputDialog(
                    title: Text(AppLocalizations.of(context)!.target_score),
                    isNumber: true,
                    val: state._selectedGame.targetScore.toString(),
                  ).show(context);

                  int? score = valStr != null ? int.tryParse(valStr) : null;
                  state.handleUpdateTargetScore(score);
                },
              ),
            ],
          )
        ],
      );
    });
  }

  List<Widget> _buildSaveOrCancelButtons(BuildContext context) {
    if (!state.isNew) return [const SizedBox.shrink()];

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomTextButton(
            onTap: state.handelCancelBtn,
            text: AppLocalizations.of(context)!.cancel,
          ),
          CustomTextButton(
            onTap: state.handelSaveBtn,
            text: AppLocalizations.of(context)!.save,
          ),
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackHeader(title: AppLocalizations.of(context)!.customize_game),
        body: Column(
          children: [
            Expanded(child: _buildSetingsList()),
            ..._buildSaveOrCancelButtons(context)
          ],
        ));
  }
}
