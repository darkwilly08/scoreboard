import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/model/Game.dart';
import 'package:anotador/pages/pick_players_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:anotador/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class MatchPreparationScreen extends StatefulWidget {
  static const String routeName = "/match/preparation";
  MatchPreparationScreen({Key? key}) : super(key: key);

  @override
  _MatchPreparationScreenState createState() => _MatchPreparationScreenState();
}

class _MatchPreparationScreenState extends State<MatchPreparationScreen> {
  late ThemeController _themeController;
  int _index = 0;

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _MatchPreparationPhoneView(this);
  }

  void handleAddPlayerBtnToFFA() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickPlayersScreen(onPlayerClicked: null)));
  }

  void handleToggleChanged(int index) {
    setState(() {
      this._index = index;
    });
  }
}

class _MatchPreparationPhoneView
    extends WidgetView<MatchPreparationScreen, _MatchPreparationScreenState> {
  const _MatchPreparationPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(icon: Icon(Icons.search), onPressed: () => null),
        IconButton(icon: Icon(Icons.add), onPressed: () => null),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final selectedGame = ModalRoute.of(context)!.settings.arguments as Game;

    return SettingsList(
      shrinkWrap: true,
      lightBackgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      darkBackgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: "Rules",
          tiles: [
            SettingsTile(
              title: "Target score",
              subtitle: selectedGame.targetScore.toString(),
              leading: Icon(Icons.adjust),
              onPressed: (BuildContext context) {
                // _showSingleChoiceDialog(context, langCode);
              },
            ),
            SettingsTile.switchTile(
              title: "Target score wins",
              leading: Icon(Icons.emoji_events),
              switchValue: selectedGame.targetScoreWins,
              onToggle: (bool value) {
                // state.handleThemeModeChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPlayerFFAHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Players",
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              CustomFloatingActionButton(
                onTap: state.handleAddPlayerBtnToFFA,
                iconData: Icons.add,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("La lista de jugadores esta vacia"),
          )
        ],
      ),
    );
  }

  Widget _buildAddTeamsHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Team A",
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              CustomFloatingActionButton(
                onTap: state.handleAddPlayerBtnToFFA,
                iconData: Icons.add,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("el team A esta vacio"),
          ),
          Row(
            children: [
              Text(
                "Team B",
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              CustomFloatingActionButton(
                onTap: state.handleAddPlayerBtnToFFA,
                iconData: Icons.add,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("el team B esta vacio"),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (state._index) {
      case 0:
        return _buildAddPlayerFFAHeader(context);
      case 1:
        return _buildAddTeamsHeader(context);
      default:
        return Text("page not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BackHeader(
              title: "New Match",
            ),
            Flexible(
              child: _buildSettingsList(context),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomToggleButton(
                firstBtnText: "FFA",
                secondBtnText: "TEAMS",
                onChanged: state.handleToggleChanged,
              ),
            ),
            _buildBody(context),
          ],
        ),
        Positioned(
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryVariant,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0))),
            child: Center(
              child: Text(
                "START",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primaryVariant),
              ),
            ),
          ),
          bottom: 0,
        )
      ],
    ));
  }
}
