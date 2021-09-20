import 'package:anotador/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      String? this.hintText,
      String? this.labelText,
      bool? this.readonly,
      Function(String)? this.onChanged,
      String? Function(String?)? this.validator,
      int? this.maxLength,
      String? this.initialValue})
      : super(key: key);

  final String? hintText;
  final String? labelText;
  final bool? readonly;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    var themeData =
        Provider.of<ThemeController>(context, listen: false).themeData;
    return TextFormField(
      cursorColor: themeData.colorScheme.secondary,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          fillColor: themeData.colorScheme.primary,
          filled: true),
      readOnly: readonly ?? false,
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      initialValue: initialValue,
    );
  }
}
