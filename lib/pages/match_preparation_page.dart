import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/pages/pick_players_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class MatchPreparationScreen extends StatefulWidget {
  static const String routeName = "/match/preparation";
  final Game selectedGame;

  const MatchPreparationScreen({Key? key, required this.selectedGame})
      : super(key: key);

  @override
  _MatchPreparationScreenState createState() => _MatchPreparationScreenState();
}

class _MatchPreparationScreenState extends State<MatchPreparationScreen> {
  late ThemeController _themeController;
  late MatchController _matchController;
  int _index = 0;
  List<User>? ffaList;
  List<User>? teamA;
  List<User>? teamB;

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);
    _matchController = Provider.of<MatchController>(context, listen: false);
    checkMatchInProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _MatchPreparationPhoneView(this);
  }

  Future<void> checkMatchInProgress() async {
    var m = await _matchController
        .getMatchInProgressByGameId(widget.selectedGame.id!);
    if (m != null) {
      _showMessageDialog(m, context);
    }
  }

  _showMessageDialog(Match m, BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("There's a match in progress"),
          content: Text("Do you want to continue the ongoing match?"),
          actions: <Widget>[
            CustomTextButton(
                onTap: () => handleContinueMatch(m),
                text: AppLocalizations.of(context)!.accept),
            CustomTextButton(
                onTap: () => handleCancelMatchesByGameId(),
                text: AppLocalizations.of(context)!.cancel),
          ],
        ),
      );

  void handleContinueMatch(Match match) {
    Navigator.of(context).pop();
    _matchController.continueMatch(match);
    if (widget.selectedGame.type.id == GameType.NORMAL) {
      Navigator.pushReplacementNamed(context, Routes.normalMatch);
    } else {
      //truco
      Navigator.pushReplacementNamed(context, Routes.trucoMatch);
    }
  }

  void handleCancelMatchesByGameId() async {
    Navigator.of(context).pop();
    await _matchController.cancelMatchesByGameId(widget.selectedGame.id!);
  }

  void handleAddPlayerBtnToFFA() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PickPlayersScreen(onConfirmSelection: (players) {
                  setState(() {
                    ffaList = players;
                  });
                })));
  }

  void handleAddPlayerBtnToTeamA() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PickPlayersScreen(onConfirmSelection: (players) {
                  setState(() {
                    teamA = players;
                  });
                })));
  }

  void handleAddPlayerBtnToTeamB() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PickPlayersScreen(onConfirmSelection: (players) {
                  setState(() {
                    teamB = players;
                  });
                })));
  }

  void handleToggleChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  void handleStartBtn() {
    var teams = ffaList!.map((u) {
      var team = Team(name: u.name, statusId: TeamStatus.PLAYING);
      team.players.add(Player(team: team, user: u));
      return team;
    }).toList();

    _matchController.start(widget.selectedGame, true, teams);
    if (widget.selectedGame.type.id == GameType.NORMAL) {
      Navigator.pushReplacementNamed(context, Routes.normalMatch);
    } else {
      //truco
      Navigator.pushReplacementNamed(context, Routes.trucoMatch);
    }
  }
}

class _MatchPreparationPhoneView
    extends WidgetView<MatchPreparationScreen, _MatchPreparationScreenState> {
  const _MatchPreparationPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildSettingsList(BuildContext context) {
    return SettingsList(
      shrinkWrap: true,
      lightBackgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      darkBackgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: AppLocalizations.of(context)!.rules,
          tiles: [
            SettingsTile(
              title: AppLocalizations.of(context)!.target_score,
              subtitle: widget.selectedGame.targetScore.toString(),
              leading: const Icon(Icons.adjust),
              onPressed: (BuildContext context) {
                // _showSingleChoiceDialog(context, langCode);
              },
            ),
            SettingsTile.switchTile(
              title: AppLocalizations.of(context)!.target_score_wins,
              leading: const Icon(Icons.emoji_events),
              switchValue: widget.selectedGame.targetScoreWins,
              onToggle: (bool value) {
                // state.handleThemeModeChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListHeader(
      String title, Function() onAction, BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        Spacer(),
        CustomFloatingActionButton(
          onTap: onAction,
          iconData: Icons.add,
        )
      ],
    );
  }

  Widget _buildListBody(
      List<User>? elements, String emptyMsg, BuildContext context) {
    if (elements == null || elements.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(emptyMsg),
      );
    } else {
      return Wrap(
          spacing: 16.0,
          children: elements.map((e) => Chip(label: Text(e.name))).toList());
    }
  }

  Widget _buildFFASection(BuildContext context) {
    var playersStr = AppLocalizations.of(context)!.players;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(playersStr, state.handleAddPlayerBtnToFFA, context),
          _buildListBody(state.ffaList,
              AppLocalizations.of(context)!.empty_list(playersStr), context)
        ],
      ),
    );
  }

  Widget _buildTeamASection(BuildContext context) {
    var teamAStr = AppLocalizations.of(context)!.team + " A";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(teamAStr, state.handleAddPlayerBtnToTeamA, context),
          _buildListBody(state.teamA,
              AppLocalizations.of(context)!.empty_list(teamAStr), context)
        ],
      ),
    );
  }

  Widget _buildTeamBSection(BuildContext context) {
    var teamBStr = AppLocalizations.of(context)!.team + " B";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(teamBStr, state.handleAddPlayerBtnToTeamB, context),
          _buildListBody(state.teamB,
              AppLocalizations.of(context)!.empty_list(teamBStr), context)
        ],
      ),
    );
  }

  Widget _buldTeamsSection(BuildContext context) {
    return Column(
      children: [_buildTeamASection(context), _buildTeamBSection(context)],
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (state._index) {
      case 0:
        return _buildFFASection(context);
      case 1:
        return _buldTeamsSection(context);
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
            BackHeader(title: AppLocalizations.of(context)!.new_match),
            Flexible(
              child: _buildSettingsList(context),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomToggleButton(
                firstBtnText: AppLocalizations.of(context)!.ffa,
                secondBtnText: AppLocalizations.of(context)!.teams,
                onChanged: state.handleToggleChanged,
              ),
            ),
            _buildBody(context),
          ],
        ),
        Positioned(
          child: InkWell(
            onTap: state.handleStartBtn,
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
                  AppLocalizations.of(context)!.start,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primaryVariant),
                ),
              ),
            ),
          ),
          bottom: 0,
        )
      ],
    ));
  }
}
