import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/controllers/locale_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late LocaleController _localeController;
  late ThemeController _themeController;

  @override
  void initState() {
    _localeController = Provider.of<LocaleController>(context, listen: false);
    _themeController = Provider.of<ThemeController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsPhoneView(this);
  }

  void handleLanguageChanged(String code) {
    _localeController.changeLanguage(code);
    Navigator.pop(context);
  }

  void handleThemeModeChanged(bool darkMode) {
    _themeController.changeMode(darkMode);
  }
}

class _SettingsPhoneView
    extends WidgetView<SettingsScreen, _SettingsScreenState> {
  const _SettingsPhoneView(state, {Key? key}) : super(state, key: key);

  _showSingleChoiceDialog(BuildContext context, String currentLangCode) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(AppLocalizations.of(context)!.languageSelector),
              content: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: AppConstants.isoLang
                        .map((langCode, langDesc) {
                          return MapEntry(
                              langCode,
                              RadioListTile(
                                value: langCode,
                                title: Text(langDesc),
                                groupValue: currentLangCode,
                                selected: currentLangCode == langCode,
                                onChanged: (String? code) {
                                  state.handleLanguageChanged(code!);
                                },
                              ));
                        })
                        .values
                        .toList(),
                  ),
                ),
              ));
        });
  }

  Widget _buildSettingsList(BuildContext context) {
    String langCode = state._localeController.locale.languageCode;
    String lang = state._localeController.getLanguage();

    bool darkMode = state._themeController.isDarkMode;

    String themeName = darkMode
        ? AppLocalizations.of(context)!.dark_theme
        : AppLocalizations.of(context)!.light_theme;

    return SettingsList(
      lightBackgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      darkBackgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: AppLocalizations.of(context)!.interface,
          tiles: [
            SettingsTile(
              title: AppLocalizations.of(context)!.language,
              subtitle: lang,
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {
                _showSingleChoiceDialog(context, langCode);
              },
            ),
            SettingsTile.switchTile(
              title: AppLocalizations.of(context)!.theme,
              subtitle: themeName,
              leading: Icon(Icons.color_lens_rounded),
              switchValue: darkMode,
              onToggle: (bool value) {
                state.handleThemeModeChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        BackHeader(
          title: AppLocalizations.of(context)!.settings,
        ),
        Expanded(child: _buildSettingsList(context))
      ],
    ));
  }
}
