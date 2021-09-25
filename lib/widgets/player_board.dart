import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/Match.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerBoard extends StatefulWidget {
  final MatchPlayer player;
  PlayerBoard({Key? key, required this.player}) : super(key: key);

  @override
  _PlayerBoardState createState() => _PlayerBoardState();
}

class _PlayerBoardState extends State<PlayerBoard> {
  late MatchController _matchController;

  @override
  void initState() {
    _matchController = Provider.of<MatchController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.player.user.name),
        Expanded(
            child: ListView(
          children: widget.player.scoreList
              .map((score) => Text(
                    score.toString(),
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        )),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomFloatingActionButton(
              onTap: () {
                setState(() {
                  _matchController.addResult(widget.player, 5);
                });
              },
              iconData: Icons.add),
        )
      ],
    );
  }
}
