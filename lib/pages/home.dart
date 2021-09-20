import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/fragments/game_list.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/drawer.dart';
import 'package:anotador/widgets/toggle_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

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
      this._index = index;
    });
  }
}

class _HomePhoneView extends WidgetView<HomeScreen, _HomeScreenState> {
  const _HomePhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 36.0, bottom: 0.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            iconSize: 32.0,
            padding: const EdgeInsets.all(0),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Image(
                image: AssetImage(AssetsConstants.scoreboard),
                height: 38,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (state._index) {
      case 0:
        return GameListScreen();
      case 1:
        return Text("page 2");
      default:
        return Text("page not found");
    }
  }

  void _drawerItemClicked(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        drawer: AppDrawer(
          onItemClicked: (route) => _drawerItemClicked(context, route),
        ),
        body: Column(
          children: [
            Builder(builder: (context) => _buildTopHeader(context)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomToggleButton(
                  firstBtnText: "Games",
                  secondBtnText: "Stats",
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
