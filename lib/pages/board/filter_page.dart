import 'package:anotador/controllers/game_controller.dart';
import 'package:anotador/controllers/stats_controller.dart';
import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/model/game.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/repositories/stats_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../patterns/widget_view.dart';
import '../../widgets/back_header.dart';

enum Period { oneMonth, sixMonths, lastCalendarYear, allTime }

class FilterPage extends StatefulWidget {
  static const String routeName = '/filterPage';

  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Set<Period> periodsSelected = <Period>{};
  Set<Game> gamesSelected = <Game>{};
  Set<User> playersSelected = <User>{};

  late final List<Game> games;
  late final StatsController _statsController;
  late final GameController _gameController;
  late final UserController _userController;

  @override
  void initState() {
    super.initState();
    _statsController = Provider.of<StatsController>(context, listen: false);
    _gameController = Provider.of<GameController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);

    _userController.initPlayerList();
    games = _gameController.games ?? [];

    gamesSelected = _statsController.filters?.games?.toSet() ?? <Game>{};
    playersSelected = _statsController.filters?.users?.toSet() ?? <User>{};
  }

  void handlePeriodSelected(bool selected, Period period) {
    if (selected) {
      setState(() {
        periodsSelected.add(period);
      });
    } else {
      setState(() {
        periodsSelected.remove(period);
      });
    }
  }

  void handleGameSelected(bool selected, Game game) {
    if (selected) {
      setState(() {
        gamesSelected.add(game);
      });
    } else {
      setState(() {
        gamesSelected.remove(game);
      });
    }
  }

  void handlePlayerSelected(bool selected, User user) {
    if (selected) {
      setState(() {
        playersSelected.add(user);
      });
    } else {
      setState(() {
        playersSelected.remove(user);
      });
    }
  }

  void clearAll() {
    setState(() {
      periodsSelected.clear();
      gamesSelected.clear();
      playersSelected.clear();
    });
  }

  void handleSave() async {
    _statsController.updateFilters(
      Filter(games: gamesSelected.toList(), users: playersSelected.toList()),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _FilterPagePhoneView(this);
  }
}

class _FilterPagePhoneView extends WidgetView<FilterPage, _FilterPageState> {
  const _FilterPagePhoneView(_FilterPageState state, {Key? key})
      : super(state, key: key);

  Widget? _buildTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(LineIcons.broom),
          onPressed: () => state.clearAll(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return TextButton(
      onPressed: state.handleSave,
      child: Text(
        AppLocalizations.of(state.context)!.save,
        style: TextStyle(
            color: Theme.of(state.context).colorScheme.secondaryContainer,
            fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeader(
        title: AppLocalizations.of(state.context)!.filters,
        trailing: _buildTrailing(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: add time period filter
                // Text(
                //   "Period",
                //   style: TextStyle(
                //     color: Theme.of(state.context)
                //         .colorScheme
                //         .secondary
                //         .withOpacity(0.7),
                //     fontSize: 18.0,
                //   ),
                // ),
                // Wrap(
                //   spacing: 5.0,
                //   children: Period.values.map((Period period) {
                //     return FilterChip(
                //       label: Text(period.name),
                //       selected: state.periodsSelected.contains(period),
                //       onSelected: (bool selected) {
                //         state.handlePeriodSelected(selected, period);
                //       },
                //     );
                //   }).toList(),
                // ),
                // SizedBox(
                //   height: 16,
                // ),
                Text(
                  AppLocalizations.of(state.context)!.games,
                  style: TextStyle(
                    color: Theme.of(state.context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7),
                    fontSize: 18.0,
                  ),
                ),
                Wrap(
                  spacing: 5.0,
                  children: state.games.map((Game game) {
                    return FilterChip(
                      label: Text(game.name),
                      selected: state.gamesSelected.contains(game),
                      onSelected: (bool selected) {
                        state.handleGameSelected(selected, game);
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  AppLocalizations.of(state.context)!.players,
                  style: TextStyle(
                    color: Theme.of(state.context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7),
                    fontSize: 18.0,
                  ),
                ),
                Consumer<UserController>(
                  builder: (BuildContext context, userController, _) {
                    final users = userController.players ?? [];
                    return Wrap(
                      spacing: 5.0,
                      children: users
                          .where((p) => p.favorite && p.id != null && p.id! > 0)
                          .toList()
                          .map((User user) {
                        return FilterChip(
                          label: Text(user.name),
                          selected: state.playersSelected.contains(user),
                          onSelected: (bool selected) {
                            state.handlePlayerSelected(selected, user);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: _buildFooter(),
                )
              ],
            )),
      ),
    );
  }
}
