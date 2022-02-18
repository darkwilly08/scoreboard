import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/controllers/match_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/model/match.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrucoBoard extends StatefulWidget {
  final Team team;
  TrucoBoard({Key? key, required this.team}) : super(key: key);

  @override
  _TrucoBoardState createState() => _TrucoBoardState();
}

class _TrucoBoardState extends State<TrucoBoard> {
  late MatchController _matchController;

  @override
  void initState() {
    _matchController = Provider.of<MatchController>(context, listen: false);
    super.initState();
  }

  void handleAddScoreBtn() {
    setState(() {
      _matchController.addResult(widget.team, 1);
    });
  }

  Widget _drawDiagonal(double angle,
      {double? top, double? right, double? left, double? bottom}) {
    return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: Transform.rotate(
          angle: angle,
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Image(
              image: AssetImage(AssetsConstants.auxLine),
            ),
          ),
        ));
  }

  Widget _drawLine(int quarter,
      {double? top, double? right, double? left, double? bottom}) {
    return Positioned(
        top: top,
        right: right,
        left: left,
        bottom: bottom,
        child: RotatedBox(
          quarterTurns: quarter,
          child: const Image(
            fit: BoxFit.scaleDown,
            image: AssetImage(AssetsConstants.trucoLine),
          ),
        ));
  }

  Widget _drawSquarePoints(int pointsToDraw, double squareHeight) {
    double spaceBetween = 10;
    squareHeight = squareHeight > 120 ? 120 : squareHeight;
    return Container(
      height: squareHeight,
      width: squareHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Stack(
          children: [
            Visibility(
                visible: pointsToDraw >= 1,
                child: _drawLine(0,
                    top: spaceBetween, bottom: spaceBetween, left: 0)),
            Visibility(
                visible: pointsToDraw >= 2,
                child: _drawLine(1,
                    top: 0, left: spaceBetween, right: spaceBetween)),
            Visibility(
                visible: pointsToDraw >= 3,
                child: _drawLine(0,
                    top: spaceBetween, bottom: spaceBetween, right: 0)),
            Visibility(
                visible: pointsToDraw >= 4,
                child: _drawLine(1,
                    bottom: 0, left: spaceBetween, right: spaceBetween)),
            Visibility(
                visible: pointsToDraw >= 5,
                child: _drawDiagonal(0,
                    left: spaceBetween,
                    right: spaceBetween,
                    top: spaceBetween)),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawScore(
      BoxConstraints constraints, TrucoGame game, int score) {
    final int squareQuantity = game.scoreInfo.squareQuantity;
    final int pointsBySquare = game.scoreInfo.pointsBySquare;
    final double squareHeight = (constraints.maxHeight / squareQuantity) - 3;

    int lastSquarePoints = score % pointsBySquare;
    int squareFilled = (score / pointsBySquare).ceil();

    List<Widget> squares = [];
    for (int i = 0; i < squareFilled; i++) {
      int pointsToDraw = pointsBySquare;
      bool isLastSquare = (i + 1) == squareFilled;
      if (isLastSquare && lastSquarePoints > 0) {
        pointsToDraw = lastSquarePoints;
      }
      squares.add(_drawSquarePoints(pointsToDraw, squareHeight));
    }

    while (squares.length < squareQuantity) {
      squares.add(SizedBox(
        height: squareHeight,
      ));
    }

    if (game.twoHalves) {
      squares.insert(3, const Divider(color: Colors.white));
    }

    return squares;
  }

  String getSubtitle(bool? areGood) {
    if (areGood == null) {
      return "";
    } else if (areGood == false) {
      return "(Malas)";
    }

    return "(Buenas)";
  }

  @override
  Widget build(BuildContext context) {
    final tGame = _matchController.match!.game as TrucoGame;
    final areGood = widget.team.areGood();
    final currentScore = widget.team.lastScore;
    return Column(
      children: [
        Text(widget.team.name + " - " + currentScore.toString()),
        Text(getSubtitle(areGood)),
        Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _drawScore(constraints, tGame, currentScore),
                );
              })),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16, top: 8),
          child: CustomFloatingActionButton(
              onTap: handleAddScoreBtn, iconData: Icons.add),
        )
      ],
    );
  }
}
