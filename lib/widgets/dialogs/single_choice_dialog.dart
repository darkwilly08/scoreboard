import 'package:flutter/material.dart';

class SingleChoiceDialog<T> {
  final Widget title;
  final List<T> items;
  final T? selected;
  const SingleChoiceDialog(
      {Key? key,
      required this.title,
      required this.items,
      required this.selected});

  Widget _builder(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map((item) => RadioListTile<T>(
                    title: Text(item.toString()),
                    value: item,
                    groupValue: selected,
                    onChanged: (value) => Navigator.pop(context, value)))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<T?> show(BuildContext context) async {
    return showDialog(context: context, builder: _builder);
  }
}
