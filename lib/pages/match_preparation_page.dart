import 'dart:developer';

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
  List<User>? playersTeamA;
  List<User>? playersTeamB;
  late String teamAName = AppLocalizations.of(context)!.team + " A";
  late String teamBName = AppLocalizations.of(context)!.team + " B";

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
    goToMatch();
  }

  void handleCancelMatchesByGameId() async {
    Navigator.of(context).pop();
    await _matchController.cancelMatchesByGameId(widget.selectedGame.id!);
  }

  void handleAddPlayerBtn(
      List<User>? unavailablePlayers, Function(List<User>?) onPlayers) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickPlayersScreen(
                unavailableUsers: unavailablePlayers,
                onConfirmSelection: onPlayers)));
  }

  void handleAddPlayerBtnToFFA() {
    handleAddPlayerBtn(null, (players) => setState(() => ffaList = players));
  }

  void handleAddPlayerBtnToTeamA() {
    handleAddPlayerBtn(
        playersTeamB, (players) => setState(() => playersTeamA = players));
  }

  void handleAddPlayerBtnToTeamB() {
    handleAddPlayerBtn(
        playersTeamA, (players) => setState(() => playersTeamB = players));
  }

  void handleToggleChanged(int index) {
    setState(() {
      ffaList = null;
      playersTeamA = null;
      playersTeamB = null;
      _index = index;
    });
  }

  List<Team>? _createTeams() {
    List<Team> teams = [];
    if (ffaList != null) {
      teams = ffaList!.map((u) {
        var team = Team(name: u.name, statusId: TeamStatus.PLAYING);
        team.players.add(Player(team: team, user: u));
        return team;
      }).toList();
    } else if (playersTeamA != null && playersTeamB != null) {
      //TODO improve this to handle N teams
      var teamA = Team(name: teamAName, statusId: TeamStatus.PLAYING);
      teamA.players =
          playersTeamA!.map((u) => Player(team: teamA, user: u)).toList();
      var teamB = Team(name: teamBName, statusId: TeamStatus.PLAYING);
      teamB.players =
          playersTeamB!.map((u) => Player(team: teamB, user: u)).toList();

      teams.add(teamA);
      teams.add(teamB);
    }

    if (teams.isEmpty) return null;

    return teams;
  }

  void handleStartBtn() {
    var teams = _createTeams();

    if (teams == null) {
      //TODO: show error message.. complete players
      return;
    }

    _matchController.start(widget.selectedGame, true, teams);
    goToMatch();
  }

  void goToMatch() {
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
                //TODO _showSingleChoiceDialog(context, langCode);
              },
            ),
            SettingsTile.switchTile(
              title: AppLocalizations.of(context)!.target_score_wins,
              leading: const Icon(Icons.emoji_events),
              switchValue: widget.selectedGame.targetScoreWins,
              onToggle: (bool value) {
                //TODO state.handleThemeModeChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListHeader(
      String title, void Function() onAction, BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const Spacer(),
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
        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
    var teamAName = AppLocalizations.of(context)!.team + " A";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(teamAName, state.handleAddPlayerBtnToTeamA, context),
          _buildListBody(state.playersTeamA,
              AppLocalizations.of(context)!.empty_list(teamAName), context)
        ],
      ),
    );
  }

  Widget _buildTeamBSection(BuildContext context) {
    var teamBName = AppLocalizations.of(context)!.team + " B";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(teamBName, state.handleAddPlayerBtnToTeamB, context),
          _buildListBody(state.playersTeamB,
              AppLocalizations.of(context)!.empty_list(teamBName), context)
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
              padding: const EdgeInsets.all(8.0),
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
