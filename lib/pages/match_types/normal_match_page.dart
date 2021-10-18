import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/Match.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/player_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NormalMatchScreen extends StatefulWidget {
  NormalMatchScreen({Key? key}) : super(key: key);

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
}

class _NormalMatchView
    extends WidgetView<NormalMatchScreen, _NormalMatchScreenState> {
  const _NormalMatchView(state, {Key? key}) : super(state, key: key);

  Widget _buildBoard() {
    List<Widget> playerBoard = [];
    for (int i = 0; i < state._matchController.match!.players.length; i++) {
      playerBoard.add(_buildPlayerBoard(i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: playerBoard,
    );
  }

  Widget _buildPlayerBoard(int index) {
    return Container(
      width: state.widthPlayerBoard,
      child: PlayerBoard(
        player: state._matchController.match!.players[index],
      ),
    );
  }

  Widget _buildMatchEndedBanner(BuildContext context) {
    final mb = MaterialBanner(
      content: Text(
        "Wasp won the match!",
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(color: Colors.black),
      ),
      leading: CircleAvatar(child: Icon(Icons.emoji_events)),
      backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
      actions: [
        TextButton(
            onPressed: null,
            child: Text(
              "RE MATCH",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: null,
            child: Text(
              "KEEP PLAYING",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: null,
            child: Text(
              "EXIT",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
    return Selector<MatchController, int>(
        selector: (_, controller) => controller.match!.status.id,
        builder: (_, matchStatusId, __) {
          if (matchStatusId == MatchStatus.ENDED) {
            return mb;
          }

          return SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    state.widthPlayerBoard = MediaQuery.of(context).size.width / 2;
    return Scaffold(
        body: Column(
      children: [
        BackHeader(
          title: AppLocalizations.of(context)!.players,
        ),
        Selector<MatchController, int>(
            selector: (_, controller) => controller.match!.status.id,
            builder: (_, data, __) {
              print('statusssssssssssss is ');
              return _buildMatchEndedBanner(context);
            }),
        Expanded(child: _buildBoard()),
      ],
    ));
  }
}
