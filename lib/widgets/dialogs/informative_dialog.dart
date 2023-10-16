import 'package:anotador/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformativeDialog {
  final Widget? title;
  final Widget? description;

  InformativeDialog({Key? key, required this.title, required this.description});

  Widget _builder(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width, child: description),
      ),
      actions: [
        CustomTextButton(
            onTap: () => Navigator.pop(context, false),
            text: AppLocalizations.of(context)!.cancel),
        CustomTextButton(
            onTap: () => _handleAccept(context),
            text: AppLocalizations.of(context)!.accept),
      ],
    );
  }

  void _handleAccept(BuildContext context) {
    Navigator.pop(context, true);
  }

  Future<bool?> show(BuildContext context) async {
    return showDialog(context: context, builder: _builder);
  }
}
