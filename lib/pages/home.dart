import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/fragments/game_list.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/drawer.dart';
import 'package:anotador/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return _HomePhoneView(this);
  }

  void handleToggleChanged(int index) {
    setState(() {
      _index = index;
    });
  }
}

class _HomePhoneView extends WidgetView<HomeScreen, _HomeScreenState> {
  const _HomePhoneView(state, {Key? key}) : super(state, key: key);

  AppBar _buildTopHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: const [
        Padding(
          padding: EdgeInsets.all(8),
          child: Image(
            image: AssetImage(AssetsConstants.scoreboard),
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (state._index) {
      case 0:
        return const GameListScreen();
      case 1:
        return const Text("page 2");
      default:
        return const Text("page not found");
    }
  }

  void _drawerItemClicked(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildTopHeader(context),
        drawer: AppDrawer(
          onItemClicked: (route) => _drawerItemClicked(context, route),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomToggleButton(
                  firstBtnText: AppLocalizations.of(context)!.games,
                  secondBtnText: AppLocalizations.of(context)!.stats,
                  onChanged: state.handleToggleChanged,
                )),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _buildBody(context),
              ),
            )
          ],
        ));
  }
}
