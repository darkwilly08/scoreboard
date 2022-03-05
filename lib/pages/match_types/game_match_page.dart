import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/match_status.dart';
import 'package:anotador/model/team.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/model/truco_game.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/in_game/menu/popup_menu.dart';
import 'package:anotador/widgets/player_board.dart';
import 'package:anotador/widgets/truco_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class GameMatchScreen extends StatefulWidget {
  static const String routeName = "/match/board";

  const GameMatchScreen({Key? key}) : super(key: key);

  @override
  _GameMatchScreenState createState() => _GameMatchScreenState();
}

class _GameMatchScreenState extends State<GameMatchScreen> {
  late MatchController _matchController;
  late double widthPlayerBoard;
  late double heightPlayerBoard;

  @override
  void initState() {
    _matchController = Provider.of<MatchController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _GameMatchView(this);
  }

  Future<bool?> handleBackClicked() async {
    return await _showMessageDialog(context);
  }

  _showMessageDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Are you sure?"),
          content:
              const Text("The match will be available to continue it later"),
          actions: <Widget>[
            CustomTextButton(
                onTap: () => Navigator.pop(context, true),
                text: AppLocalizations.of(context)!.accept),
            CustomTextButton(
                onTap: () => Navigator.pop(context, false),
                text: AppLocalizations.of(context)!.cancel),
          ],
        ),
      );

  Future<bool> _onWillPop() async {
    bool? isConfirmed = await handleBackClicked();
    if (isConfirmed != null && isConfirmed) {
      return true;
    }
    return false;
  }

  Future<void> handleBackArrow() async {
    bool? isConfirmed = await handleBackClicked();
    if (isConfirmed != null && isConfirmed) {
      Navigator.pop(context);
    }
  }

  void handleRematchButton() {
    _matchController.restartMatch();
  }

  void handleKeepPlayingButton() {
    // TODO: Add functionality.
    return;
  }

  void handleExitButton() {
    Navigator.pop(context);
  }
}

class _GameMatchView
    extends WidgetView<GameMatchScreen, _GameMatchScreenState> {
  const _GameMatchView(state, {Key? key}) : super(state, key: key);

  Widget _buildBoard() {
    List<Widget> teamBoardList = [];
    for (int i = 0; i < state._matchController.match!.teams!.length; i++) {
      if (i % 2 != 0) {
        teamBoardList.add(const VerticalDivider(
          width: 1,
          color: Colors.white,
        ));
      }
      teamBoardList.add(_buildTeamBoard(i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: teamBoardList,
    );
  }

  Widget _buildTeamBoard(int index) {
    Team team = state._matchController.match!.teams![index];
    Widget board = state._matchController.match!.game is TrucoGame
        ? TrucoBoard(team: team)
        : TeamBoard(team: team);
    return SizedBox(
      width: state.widthPlayerBoard - 10,
      child: board,
    );
  }

  Widget _buildMatchEndedBanner(Team team, BuildContext context) {
    return MaterialBanner(
      content: Text(
        "${team.name} won the match!",
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(color: Colors.black),
      ),
      leading: const CircleAvatar(child: Icon(Icons.emoji_events)),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      actions: [
        TextButton(
            onPressed: state.handleRematchButton,
            child: const Text(
              "RE MATCH",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: state.handleKeepPlayingButton,
            child: const Text(
              "KEEP PLAYING",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: state.handleExitButton,
            child: const Text(
              "EXIT",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    state.widthPlayerBoard = MediaQuery.of(context).size.width /
        state._matchController.match!.teams!.length;
    return WillPopScope(
        child: Scaffold(
            appBar: BackHeader(
              title: state._matchController.match!.game.name,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => state.handleBackArrow(),
              ),
              trailing: InGamePopupMenu(
                skip: state._matchController.match!.game is TrucoGame ? 1 : 0,
              ),
            ),
            body: Column(
              children: [
                Consumer<MatchController>(
                    builder: (context, matchController, _) {
                  final m = matchController.match!;
                  final aux = m.teams!
                      .where((element) => element.status.id == TeamStatus.WON);
                  if (aux.isNotEmpty && m.status.id == MatchStatus.ENDED) {
                    final wonTeam = aux.single;
                    return _buildMatchEndedBanner(wonTeam, context);
                  }
                  return const SizedBox.shrink();
                }),
                Selector<MatchController, int?>(
                    builder: (context, matchId, _) {
                      return Expanded(child: _buildBoard());
                    },
                    selector: (_, matchController) =>
                        matchController.match?.id),
              ],
            )),
        onWillPop: state._onWillPop);
  }
}
