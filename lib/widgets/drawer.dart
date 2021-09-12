import 'package:anotador/themes/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key, Function(String)? onItemClicked}) : super(key: key);

  Function(String)? onItemClicked;

  Widget _createHeader(BuildContext context) {
    return SizedBox(
        height: 100,
        child: DrawerHeader(
            margin: EdgeInsets.zero,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(AppLocalizations.of(context)!.title, style: AppTheme.drawerTitleStyle)
                  ]),
            ) ));
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createItems(BuildContext context) {
    return Column(
      children: [
        _createDrawerItem(
            icon: Icons.settings, text: AppLocalizations.of(context)!.settings, onTap: () {}),
      ],
    );
  }

  Widget _createFooter() {
    return const Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Versión 1.2.0'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [_createHeader(context), _createItems(context), _createFooter()],
      ),
    );
  }
}
