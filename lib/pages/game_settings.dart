import 'package:anotador/patterns/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

import '../widgets/back_header.dart';

class GameSettings extends StatefulWidget {
  const GameSettings({Key? key}) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
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
      appBar: BackHeader(title: AppLocalizations.of(context)!.more_settings),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Básico'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const Text('Nombre del juego'),
                value: const Text('Truco'),
              ),
              SettingsTile.navigation(
                title: const Text('Puntos a alcanzar'),
                value: const Text('30'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                title: const Text('Ganar al alcanzar puntaje'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
