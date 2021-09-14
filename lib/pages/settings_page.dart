import 'package:anotador/controllers/locale_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 36.0, bottom: 0.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: AppTheme.boldStyle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Image(
                image: AssetImage("assets/icons/scoreboard.png"),
                height: 38,
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _buildTopHeader(context),
        Expanded(child: _buildSettingsList(context))
      ],
    ));
  }

  Widget _buildSettingsList(BuildContext context) {
    String lang =
        Provider.of<LocaleController>(context, listen: false).getLanguage();

    bool isDarkMode =
        Provider.of<ThemeController>(context, listen: false).isDarkMode;
    String themeName = isDarkMode
        ? AppLocalizations.of(context)!.dark_theme
        : AppLocalizations.of(context)!.light_theme;

    return SettingsList(
      lightBackgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      // backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      darkBackgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: AppLocalizations.of(context)!.interface,
          tiles: [
            SettingsTile(
              title: AppLocalizations.of(context)!.language,
              subtitle: lang,
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile.switchTile(
              title: AppLocalizations.of(context)!.theme,
              subtitle: themeName,
              leading: Icon(Icons.color_lens_rounded),
              switchValue: true,
              onToggle: (bool value) {},
            ),
          ],
        ),
      ],
    );
  }
}
