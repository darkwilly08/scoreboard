import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.readonly,
      this.onChanged,
      this.validator,
      this.maxLength,
      this.initialValue,
      this.textInputType,
      this.inputFormatters})
      : super(key: key);

  final String? hintText;
  final String? labelText;
  final bool? readonly;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? initialValue;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText, labelText: labelText, filled: true),
      readOnly: readonly ?? false,
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      initialValue: initialValue,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
    );
  }
}
