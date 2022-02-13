import 'dart:math';

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
  int? _numberField;
  int _currentValue = 10;

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

  @override
  Widget build(BuildContext context) {
    final tGame = _matchController.match!.game as TrucoGame;
    final currentScore = widget.team.scoreList.last;
    String good = "Malas";
    if (tGame.twoHalves && currentScore >= (tGame.targetScore / 2)) {
      good = "Buenas";
    }
    return Column(
      children: [
        Text(widget.team.name + " - " + currentScore.toString()),
        Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: pi / 2,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Image(
                                  image: AssetImage(AssetsConstants.auxLine),
                                ),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: 0,
                              alignment: Alignment.bottomLeft,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 0,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        // Transform.rotate(
                        //   origin: Offset.zero,
                        //   alignment: Alignment.bottomRight,
                        //   angle: pi / 4,
                        //   child: Image(
                        //     height: 100,
                        //     fit: BoxFit.cover,
                        //     image: AssetImage(AssetsConstants.trucoLine),
                        //   ),
                        // ),

                        Positioned(
                            left: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: pi / 2,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Image(
                                  image: AssetImage(AssetsConstants.auxLine),
                                ),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: 0,
                              alignment: Alignment.bottomLeft,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 0,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        // Transform.rotate(
                        //   origin: Offset.zero,
                        //   alignment: Alignment.bottomRight,
                        //   angle: pi / 4,
                        //   child: Image(
                        //     height: 100,
                        //     fit: BoxFit.cover,
                        //     image: AssetImage(AssetsConstants.trucoLine),
                        //   ),
                        // ),

                        Positioned(
                            left: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: pi / 2,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Image(
                                  image: AssetImage(AssetsConstants.auxLine),
                                ),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: 0,
                              alignment: Alignment.bottomLeft,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            )),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: RotatedBox(
                              quarterTurns: 0,
                              child: Image(
                                image: AssetImage(AssetsConstants.trucoLine),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              )),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomFloatingActionButton(
              onTap: handleAddScoreBtn, iconData: Icons.add),
        )
      ],
    );
  }
}
