import 'package:anotador/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformativeDialog {
  final Widget? title;

  InformativeDialog({Key? key, required this.title});

  Widget _builder(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child:
            SizedBox(width: MediaQuery.of(context).size.width, child: Text("""
            Para poder realizar el backup de tus datos, necesitás habilitar el permiso de almacenamiento en tu dispositivo. 
            Para hacerlo, debes ir a la configuración de la aplicación.
                """)),
      ),
      actions: [
        CustomTextButton(
            onTap: () => _handleAccept(context), text: "Entendido"),
        CustomTextButton(
            onTap: () => Navigator.pop(context, false),
            text: AppLocalizations.of(context)!.cancel),
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
