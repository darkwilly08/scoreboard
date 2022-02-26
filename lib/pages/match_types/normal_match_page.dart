import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/match_status.dart';
import 'package:anotador/model/team.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:anotador/widgets/player_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NormalMatchScreen extends StatefulWidget {
  static const String routeName = "/match/normal";

  const NormalMatchScreen({Key? key}) : super(key: key);

  @override
  _NormalMatchScreenState createState() => _NormalMatchScreenState();
}

class _NormalMatchScreenState extends State<NormalMatchScreen> {
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
    return _NormalMatchView(this);
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

  void handleExitBtn() {
    Navigator.pop(context);
  }
}

class _NormalMatchView
    extends WidgetView<NormalMatchScreen, _NormalMatchScreenState> {
  const _NormalMatchView(state, {Key? key}) : super(state, key: key);

  Widget _buildBoard() {
    List<Widget> teamBoardList = [];
    for (int i = 0; i < state._matchController.match!.teams!.length; i++) {
      teamBoardList.add(_buildTeamBoard(i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: teamBoardList,
    );
  }

  Widget _buildTeamBoard(int index) {
    return SizedBox(
      width: state.widthPlayerBoard,
      child: TeamBoard(
        team: state._matchController.match!.teams![index],
      ),
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
        const TextButton(
            onPressed: null,
            child: Text(
              "RE MATCH",
              style: TextStyle(color: Colors.black),
            )),
        const TextButton(
            onPressed: null,
            child: Text(
              "KEEP PLAYING",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: state.handleExitBtn,
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
            body: Column(
          children: [
            BackHeader(
              title: state._matchController.match!.game.name,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => state.handleBackArrow(),
              ),
            ),
            Consumer<MatchController>(builder: (context, matchController, _) {
              final m = matchController.match!;
              final aux = m.teams!
                  .where((element) => element.status.id == TeamStatus.WON);
              if (aux.isNotEmpty && m.status.id == MatchStatus.ENDED) {
                final wonTeam = aux.single;
                return _buildMatchEndedBanner(wonTeam, context);
              }
              return const SizedBox.shrink();
            }),
            // Selector<MatchController, int>(
            //     selector: (_, controller) => controller.match!.status.id,
            //     builder: (_, data, __) {
            //       final m = state._matchController.match!;
            //       final aux = m.teams!
            //           .where((element) => element.status.id == TeamStatus.WON);
            //       if (aux.isNotEmpty && m.status.id == MatchStatus.ENDED) {
            //         final wonTeam = aux.single;
            //         return _buildMatchEndedBanner(wonTeam, context);
            //       }
            //       return const SizedBox.shrink();
            //     }),
            Expanded(child: _buildBoard()),
          ],
        )),
        onWillPop: state._onWillPop);
  }
}
