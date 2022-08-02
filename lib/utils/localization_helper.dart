import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationHelper {
  BuildContext context;

  LocalizationHelper._({required this.context});

  static LocalizationHelper of(BuildContext context) {
    return LocalizationHelper._(context: context);
  }

  String get(String messageId) {
    switch (messageId) {
      case 'add_team':
        return AppLocalizations.of(context)!.add_team;
      case 'restart_match':
        return AppLocalizations.of(context)!.restart_match;
      case 'exit':
        return AppLocalizations.of(context)!.exit;
      case 'settings':
        return AppLocalizations.of(context)!.settings;
      case 'es':
        return AppLocalizations.of(context)!.es;
      case 'en':
        return AppLocalizations.of(context)!.en;
      default:
        return messageId;
    }
  }
}
