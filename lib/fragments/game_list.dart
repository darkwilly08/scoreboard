import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameListScreen> {
  late ThemeController _themeController;
  late GameController _gameController;

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);
    _gameController = Provider.of<GameController>(context, listen: false);
    _gameController.initGameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _GamesPhoneView(this);
  }

  void handlePlayGameClicked(Game game) {
    Navigator.pushNamed(
      context,
      Routes.matchPreparation,
      arguments: game,
    );
  }
}

class _GamesPhoneView extends WidgetView<GameListScreen, _GameScreenState> {
  const _GamesPhoneView(state, {Key? key}) : super(state, key: key);

  Widget makeListTile(Game game) => Container(
          child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        title: Text(
          game.name,
          style: TextStyle(
              color: Theme.of(state.context).colorScheme.secondary,
              fontSize: 22.0),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                game.won.toString(),
                style: Theme.of(state.context).textTheme.subtitle2,
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                LineIcons.trophy,
                size: 18.0,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                game.lost.toString(),
                style: Theme.of(state.context).textTheme.subtitle2,
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                LineIcons.skullCrossbones,
                size: 18.0,
              )
            ],
          ),
        ),
        trailing: CustomFloatingActionButton(
          onTap: () {
            state.handlePlayGameClicked(game);
          },
          iconData: LineIcons.play,
        ),
      ));

  Widget _buildList(BuildContext context) {
    return Consumer<GameController>(builder: (context, gameController, _) {
      List<Widget> rows = [];
      var games = gameController.games;
      if (games == null) {
        return const CircularProgressIndicator();
      }
      if (games.isNotEmpty) {
        for (var game in games) {
          rows.add(makeListTile(game));
        }
      } else {
        return const Text("data");
      }

      return ListView(
        children: rows,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildList(context),
    );
  }
}
