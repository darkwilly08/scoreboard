import 'package:anotador/routes/routes.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key, required Function(String) this.onItemClicked})
      : super(key: key);

  final Function(String) onItemClicked;

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
                    Text(AppLocalizations.of(context)!.title,
                        style: AppTheme.drawerTitleStyle)
                  ]),
            )));
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
            icon: Icons.settings,
            text: AppLocalizations.of(context)!.settings,
            onTap: () {
              onItemClicked(Routes.settings);
            }),
      ],
    );
  }

  Widget _createFooter(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
              ' ${AppLocalizations.of(context)!.version} ${AppData.packageInfo.version}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _createHeader(context),
          _createItems(context),
          _createFooter(context)
        ],
      ),
    );
  }
}
