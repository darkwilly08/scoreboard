import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputDialog {
  final Widget? title;
  final bool isNumber;
  String? val;

  InputDialog(
      {Key? key, required this.title, required this.isNumber, this.val});

  Widget _builder(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: isNumber
              ? CustomTextFormField(
                  textInputType: TextInputType.number,
                  onChanged: (val) => this.val = val,
                  initialValue: val,
                  inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ])
              : CustomTextFormField(
                  onChanged: (val) => this.val = val,
                  initialValue: val,
                ),
        ),
      ),
      actions: [
        CustomTextButton(
            onTap: () => _handleAccept(context),
            text: AppLocalizations.of(context)!.accept),
        CustomTextButton(
            onTap: () => Navigator.pop(context, null),
            text: AppLocalizations.of(context)!.cancel),
      ],
    );
  }

  void _handleAccept(BuildContext context) {
    Navigator.pop(context, val);
  }

  Future<String?> show(BuildContext context) async {
    return showDialog(context: context, builder: _builder);
  }
}
