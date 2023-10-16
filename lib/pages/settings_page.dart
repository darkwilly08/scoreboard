import 'package:anotador/backup_and_restore/backup_and_restore.dart';
import 'package:anotador/backup_and_restore/models/backup.dart';
import 'package:anotador/backup_and_restore/models/backup_type.dart';
import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/controllers/locale_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/main.dart';
import 'package:anotador/model/custom_locale.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/utils/localization_helper.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/dialogs/informative_dialog.dart';
import 'package:anotador/widgets/dialogs/single_choice_dialog.dart';
import 'package:anotador/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

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
  }

  void handleThemeModeChanged(bool darkMode) {
    _themeController.changeMode(darkMode);
  }

  void handleBackupPressed() async {
    final backupOptions = AppConstants.backupOptions.entries
        .map((e) => Backup(e.key, LocalizationHelper.of(context).get(e.value)))
        .toList();

    final backupOptionSelected = await SingleChoiceDialog<Backup>(
            title: Text(
              AppLocalizations.of(context)!.backup_options_title,
              textAlign: TextAlign.center,
            ),
            items: backupOptions,
            selected: null)
        .show(context);

    if (backupOptionSelected == null) return;

    if (!mounted) return;

    if (backupOptionSelected.type == BackupType.googleDrive) {
      ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
        AppLocalizations.of(context)!.comingSoon,
      ));
      return;
    }

    final backup =
        await BackupAndRestore.instance.backup(backupOptionSelected.type);

    if (!mounted) return;

    if (backup.result == null) {
      final showSettings = await InformativeDialog(
        title: Text(AppLocalizations.of(context)!.access_denied),
        description:
            Text(AppLocalizations.of(context)!.access_denied_description),
      ).show(context);

      if (showSettings == true) {
        openAppSettings();
      }

      return;
    }

    final snackBar = SuccessSnackBar(
      AppLocalizations.of(context)!.backup_success,
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );

    // TODO: save backup date
  }

  void handleRestorePressed() {
    BackupAndRestore.instance.restore().then((_) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.restore_success),
                content: SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(AppLocalizations.of(context)!
                          .restore_success_message)),
                ),
                actions: [
                  CustomTextButton(
                    onTap: () {
                      RestartWidget.restartApp(context);
                    },
                    text: AppLocalizations.of(context)!.reload,
                  ),
                ],
              ));
    }).catchError((e) {
      if (e is ArgumentError) {
        ScaffoldMessenger.of(context).showSnackBar(
          DangerSnackBar(
            Text(AppLocalizations.of(context)!.restore_error_invalid_file),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        DangerSnackBar(
          Text(AppLocalizations.of(context)!.restore_error_general),
        ),
      );
    });
  }
}

class _SettingsPhoneView
    extends WidgetView<SettingsScreen, _SettingsScreenState> {
  const _SettingsPhoneView(state, {Key? key}) : super(state, key: key);

  _showLanguagePickerDialog(BuildContext context, CustomLocale selected) async {
    var dialog = SingleChoiceDialog<CustomLocale>(
      title: Text(AppLocalizations.of(context)!.languageSelector),
      items: AppConstants
          .languages, // TODO: Find a way to pass translated language
      selected: selected,
    );
    CustomLocale? locale = await dialog.show(context);
    if (locale != null) {
      state.handleLanguageChanged(locale.languageCode);
    }
  }

  Widget _buildSettingsList(BuildContext context,
      ThemeController themeController, LocaleController localeController) {
    bool darkMode = themeController.isDarkMode;

    String themeName = darkMode
        ? AppLocalizations.of(context)!.dark_theme
        : AppLocalizations.of(context)!.light_theme;

    return SettingsList(
      shrinkWrap: true,
      contentPadding: const EdgeInsetsDirectional.all(0),
      darkTheme: SettingsThemeData(
          settingsListBackground: AppTheme.darkTheme.scaffoldBackgroundColor),
      lightTheme: SettingsThemeData(
          settingsListBackground: AppTheme.lightTheme.scaffoldBackgroundColor),
      sections: [
        SettingsSection(
          title: Text(AppLocalizations.of(context)!.interface,
              style: TextStyle(
                  color: Theme.of(state.context).colorScheme.secondary)),
          tiles: [
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.language),
              value: Text(
                LocalizationHelper.of(context).get(
                  localeController.customLocale.languageCode,
                ),
              ),
              leading: const Icon(LineIcons.globe),
              onPressed: (BuildContext context) {
                _showLanguagePickerDialog(
                  context,
                  localeController.customLocale,
                );
              },
            ),
            SettingsTile.switchTile(
              title: Text(AppLocalizations.of(context)!.theme),
              description: Text(themeName),
              leading: const Icon(LineIcons.palette),
              initialValue: darkMode,
              onToggle: (bool value) {
                state.handleThemeModeChanged(value);
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.backup),
              value: Text(AppLocalizations.of(context)!.manual),
              leading: const Icon(LineIcons.download),
              onPressed: (BuildContext context) {
                state.handleBackupPressed();
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.restore),
              value: Text(AppLocalizations.of(context)!.pick_backup_file),
              leading: const Icon(LineIcons.upload),
              onPressed: (BuildContext context) {
                state.handleRestorePressed();
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
        appBar: BackHeader(
          title: AppLocalizations.of(context)!.settings,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer2<ThemeController, LocaleController>(
                builder: (context, themeController, localeController, _) {
              return _buildSettingsList(
                  context, themeController, localeController);
            })
          ],
        ));
  }
}
