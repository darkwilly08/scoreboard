import 'package:anotador/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomToggleButton extends StatefulWidget {
  final String firstBtnText;
  final IconData? firstBtnIcon;
  final String secondBtnText;
  final IconData? secondBtnIcon;
  final bool? isFirstBtnSelected;
  final Function(int index)? onChanged;

  CustomToggleButton(
      {Key? key,
      required this.firstBtnText,
      this.firstBtnIcon,
      required this.secondBtnText,
      this.secondBtnIcon,
      this.isFirstBtnSelected,
      this.onChanged})
      : super(key: key);

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late ThemeController _themeController;

  bool isFirstBtnSelected = true;
  late ButtonStyle selectedBtnStyle;
  late EdgeInsetsGeometry padding;

  void handleUnSelectedTap() {
    setState(() {
      isFirstBtnSelected = !isFirstBtnSelected;

      if (widget.onChanged != null) {
        int index = isFirstBtnSelected ? 0 : 1;
        widget.onChanged!(index);
      }
    });
  }

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);

    padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    isFirstBtnSelected = widget.isFirstBtnSelected ?? true;
    super.initState();
  }

  Widget _buildBtnSelected(String text, IconData? iconData) {
    TextStyle selectedTextStyle = TextStyle(
        color: _themeController.themeData.colorScheme.secondary,
        fontSize: 18.0);

    Widget btn;
    if (iconData != null) {
      btn = TextButton.icon(
        onPressed: null,
        icon: Icon(iconData),
        label: Text(text, style: selectedTextStyle),
      );
    } else {
      btn = Container(
        decoration: BoxDecoration(
            color: _themeController.themeData.colorScheme.primary,
            borderRadius: BorderRadius.circular(16.0)),
        padding: padding,
        child: Text(text, style: selectedTextStyle),
      );
    }

    return btn;
  }

  Widget _buildUnselected(String text, IconData? iconData) {
    TextStyle unSelectedTextStyle =
        TextStyle(fontSize: 18.0, color: Colors.grey.shade600);
    Widget btn;
    if (iconData != null) {
      btn = TextButton.icon(
          onPressed: null, icon: Icon(iconData), label: Text(text));
    } else {
      btn = InkWell(
          onTap: handleUnSelectedTap,
          child: Container(
            padding: padding,
            child: Text(
              text,
              style: unSelectedTextStyle,
            ),
          ));
    }
    return btn;
  }

  @override
  Widget build(BuildContext context) {
    Widget btn1;
    Widget btn2;
    if (isFirstBtnSelected) {
      btn1 = _buildBtnSelected(widget.firstBtnText, widget.firstBtnIcon);
      btn2 = _buildUnselected(widget.secondBtnText, widget.secondBtnIcon);
    } else {
      btn1 = _buildUnselected(widget.firstBtnText, widget.firstBtnIcon);
      btn2 = _buildBtnSelected(widget.secondBtnText, widget.secondBtnIcon);
    }

    return Row(
      children: [
        btn1,
        SizedBox(
          width: 10,
        ),
        btn2
      ],
    );
  }
}
