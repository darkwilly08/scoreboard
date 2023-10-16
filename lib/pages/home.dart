import 'package:anotador/fragments/game_list.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/widgets/drawer.dart';
import 'package:anotador/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';

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

  void handleCreateCustomGame() {
    Navigator.pushNamed(context, Routes.gameSettings,
        arguments: {'isNew': true});
  }
}

class _HomePhoneView extends WidgetView<HomeScreen, _HomeScreenState> {
  const _HomePhoneView(state, {Key? key}) : super(state, key: key);

  AppBar _buildTopHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        state._index == 0
            ? IconButton(
                icon: const Icon(LineIcons.plus),
                onPressed: () => state.handleCreateCustomGame(),
              )
            : IconButton(
                icon: const Icon(LineIcons.filter),
                onPressed: () => {},
              ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (state._index) {
      case 0:
        return const GameListScreen();
      case 1:
        // TODO: revert this when stats are ready
        // return const BoardPage();
        return Text(AppLocalizations.of(context)!.comingSoon);
      default:
        return Text(AppLocalizations.of(context)!.page_not_found);
    }
  }

  Widget _buildFooter() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(state.context, Routes.boardTable);
      },
      child: Text(
        AppLocalizations.of(state.context)!.history,
        style: TextStyle(
            color: Theme.of(state.context).colorScheme.secondaryContainer,
            fontSize: 16),
      ),
    );
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
            ),
            _buildFooter(),
          ],
        ));
  }
}
