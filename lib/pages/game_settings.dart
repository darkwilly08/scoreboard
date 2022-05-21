import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/dialogs/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../widgets/back_header.dart';

class GameSettings extends StatefulWidget {
  const GameSettings({Key? key}) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  late GameController _gameController;
  late Game _selectedGame;

  void handleUpdateTargetScoreWins(bool newValue) {}

  @override
  void initState() {
    _gameController = Provider.of<GameController>(context, listen: false);
    _selectedGame = _gameController.selectedGame!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _GameSettingsPhoneView(this);
  }
}

class _GameSettingsPhoneView
    extends WidgetView<GameSettings, _GameSettingsState> {
  const _GameSettingsPhoneView(_GameSettingsState state, {Key? key})
      : super(state, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(title: AppLocalizations.of(context)!.customize_game),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.basic),
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

                  if (newGameName != null) {
                    state._gameController.updateGameName(newGameName);
                  }
                },
              ),
              // TODO: Ver con fran si esto se podria o hacemos verga todo
              SettingsTile.navigation(
                leading: const Icon(LineIcons.hashtag),
                title: Text(AppLocalizations.of(context)!.scoreboard_type),
                value: Text(state._selectedGame.type.id.toString()),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.rules),
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
                  if (score != null) {
                    state._gameController.updateTargetScore(score);
                  }
                },
              ),
              SettingsTile.switchTile(
                leading: const Icon(LineIcons.trophy),
                onToggle: state._gameController.updateTargetScoreWins,
                initialValue: state._selectedGame.targetScoreWins,
                title: Text(AppLocalizations.of(context)!.target_score_wins),
              ),
              SettingsTile.switchTile(
                leading: const Icon(LineIcons.minusCircle),
                onToggle: state._gameController.updateNegativeAllowed,
                initialValue: state._selectedGame.isNegativeAllowed,
                title: Text(AppLocalizations.of(context)!.is_negative_allowed),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
