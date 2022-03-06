import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/model/game_type.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/model/player.dart';
import 'package:anotador/model/team.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/model/truco/truco_score.dart';
import 'package:anotador/model/truco_game.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/pages/pick_players_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/dialogs/input_dialog.dart';
import 'package:anotador/widgets/dialogs/single_choice_dialog.dart';
import 'package:anotador/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
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
  late MatchController _matchController;
  late GameController _gameController;
  int _index = 0;
  List<User>? ffaList;
  List<User>? playersTeamA;
  List<User>? playersTeamB;
  late String teamAName = AppLocalizations.of(context)!.team + " A";
  late String teamBName = AppLocalizations.of(context)!.team + " B";

  @override
  void initState() {
    _matchController = Provider.of<MatchController>(context, listen: false);
    _gameController = Provider.of<GameController>(context, listen: false);
    _initGameController();
    checkMatchInProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _MatchPreparationPhoneView(this);
  }

  Future<void> _initGameController() async {
    await _gameController.setSelected(widget.selectedGame);
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
          title: const Text("There's a match in progress"),
          content: const Text("Do you want to continue the ongoing match?"),
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

  void handleAddPlayerBtn(List<User>? alreadySelectedPlayers,
      List<User>? unavailablePlayers, Function(List<User>?) onPlayers) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickPlayersScreen(
                preSelectedUsers: alreadySelectedPlayers,
                unavailableUsers: unavailablePlayers,
                onConfirmSelection: onPlayers)));
  }

  void handleAddPlayerBtnToFFA() {
    handleAddPlayerBtn(
        ffaList, null, (players) => setState(() => ffaList = players));
  }

  void handleAddPlayerBtnToTeamA() {
    handleAddPlayerBtn(playersTeamA, playersTeamB,
        (players) => setState(() => playersTeamA = players));
  }

  void handleAddPlayerBtnToTeamB() {
    handleAddPlayerBtn(playersTeamB, playersTeamA,
        (players) => setState(() => playersTeamB = players));
  }

  void handleRulesTargetScoreChanged(int targetScore) {
    _gameController.updateTargetScore(targetScore);
  }

  //only for Truco
  void handleRulesScoreInfoChanged(TrucoScore scoreInfo) {
    _gameController.updateScoreInfo(scoreInfo);
  }

  void handleRulesTargetScoreWinsChanged(bool targetScoreWins) {
    _gameController.updateTargetScoreWins(targetScoreWins);
  }

  void handleMoreSettings() {
    //TODO open new route to handle, allowNegatives, dropdown and any new feature
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
      teams = Team.createTeam(ffaList!, oneTeamPerUser: true);
    } else if (playersTeamA != null && playersTeamB != null) {
      //TODO improve this to handle N teams
      var teamA = Team.createTeam(playersTeamA!, teamName: teamAName).single;
      var teamB = Team.createTeam(playersTeamB!, teamName: teamBName).single;

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
    //truco
    Navigator.pushReplacementNamed(context, Routes.matchBoard);
  }
}

class _MatchPreparationPhoneView
    extends WidgetView<MatchPreparationScreen, _MatchPreparationScreenState> {
  const _MatchPreparationPhoneView(state, {Key? key}) : super(state, key: key);

  _showTargetScoreInputDialog(BuildContext context) async {
    var dialog = InputDialog(
        title: Text(AppLocalizations.of(context)!.target_score),
        isNumber: true,
        val: widget.selectedGame.targetScore.toString());
    String? valStr = await dialog.show(context);

    int? score = valStr != null ? int.tryParse(valStr) : null;
    if (score != null) {
      state.handleRulesTargetScoreChanged(score);
    }
  }

  _showTrucoScoreSingleChoiceDialog(BuildContext context) async {
    var dialog = SingleChoiceDialog<TrucoScore>(
        title: Text(AppLocalizations.of(context)!.target_score +
            " (${AppLocalizations.of(context)!.bad_plus_good.toLowerCase()})"),
        items: AppConstants.trucoPossibleScores,
        selected: (widget.selectedGame as TrucoGame).scoreInfo);
    TrucoScore? trucoScore = await dialog.show(context);
    if (trucoScore != null) {
      state.handleRulesScoreInfoChanged(trucoScore);
    }
  }

  Widget _buildSettingsList(BuildContext context) {
    //TODO editable game settings before start the match
    return Consumer<GameController>(builder: (context, gameController, _) {
      return SettingsList(
        contentPadding: const EdgeInsetsDirectional.all(0),
        shrinkWrap: true,
        darkTheme: SettingsThemeData(
            settingsListBackground: AppTheme.darkTheme.scaffoldBackgroundColor),
        lightTheme: SettingsThemeData(
            settingsListBackground:
                AppTheme.lightTheme.scaffoldBackgroundColor),
        sections: [
          SettingsSection(
            title: Text(
              AppLocalizations.of(context)!.rules,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.target_score),
                value: widget.selectedGame is! TrucoGame
                    ? Text(widget.selectedGame.targetScore.toString())
                    : Text((widget.selectedGame as TrucoGame)
                        .scoreInfo
                        .toString()),
                leading: const Icon(Icons.adjust),
                onPressed: (BuildContext context) {
                  if (widget.selectedGame is TrucoGame) {
                    _showTrucoScoreSingleChoiceDialog(context);
                  } else {
                    _showTargetScoreInputDialog(context);
                  }
                },
              ),
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.target_score_wins),
                leading: const Icon(Icons.emoji_events),
                initialValue: widget.selectedGame.targetScoreWins,
                onToggle: widget.selectedGame is! TrucoGame
                    ? state.handleRulesTargetScoreWinsChanged
                    : null,
              ),
              SettingsTile(
                title: const Text("More settings"),
                leading: const Icon(Icons.tune),
                onPressed: (BuildContext context) {
                  //TODO handleMoreSettings(context);
                },
              )
            ],
          ),
        ],
      );
    });
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
        return const Text("page not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackHeader(title: AppLocalizations.of(context)!.new_match),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSettingsList(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomToggleButton(
                    firstBtnText: AppLocalizations.of(context)!.ffa,
                    secondBtnText: AppLocalizations.of(context)!.teams,
                    onChanged: state.handleToggleChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildBody(context),
                ),
              ],
            ),
            Positioned(
              child: InkWell(
                onTap: state.handleStartBtn,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          topRight: Radius.circular(60.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset:
                              const Offset(0, -1), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.start,
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
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
