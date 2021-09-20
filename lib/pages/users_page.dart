import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/model/User.dart';
import 'package:anotador/pages/add_user_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/box_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  static const String routeName = "/users";

  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UserscreenState createState() => _UserscreenState();
}

class _UserscreenState extends State<UsersScreen> {
  late ThemeController _themeController;
  late UserController _userController;

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);
    _userController = Provider.of<UserController>(context, listen: false);

    _userController.initPlayerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _UsersPhoneView(this);
  }

  void handleAddPlayerBtn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddUserScreen()));
  }

  void handleEditPlayerTap(User user) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddUserScreen(
                  user: user,
                )));
  }

  Future<void> handleToggleFavorite(User user) async {
    user.favorite = !user.favorite;
    await _userController.EditPlayer(user);
  }

  void handleThemeModeChanged(bool darkMode) {
    _themeController.changeMode(darkMode);
  }
}

class _UsersPhoneView extends WidgetView<UsersScreen, _UserscreenState> {
  const _UsersPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildUserList(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, _) {
      List<Widget> rows = [];
      var players = userController.players;
      if (players == null) {
        return CircularProgressIndicator();
      }
      if (players.isNotEmpty) {
        players.forEach((player) {
          rows.add(makeListTile(player));
        });
      } else {
        return Text("data");
      }

      return ListView(
        children: rows,
      );
    });
  }

  Card makeListTile(User user) => Card(
      elevation: 4.0,
      margin: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
          child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          user.name,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        leading: BoxTile(
          child: Text(
            user.initial,
            style: TextStyle(
                fontSize: 20,
                color: state._themeController.themeData.colorScheme.primary),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.star,
            color: user.favorite
                ? state._themeController.themeData.colorScheme.secondary
                : state._themeController.themeData.colorScheme.primaryVariant,
          ),
          onPressed: () {
            state.handleToggleFavorite(user);
          },
        ),
        onTap: () {
          state.handleEditPlayerTap(user);
        },
      )));

  Widget _buildTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(icon: Icon(Icons.search), onPressed: () => null),
        IconButton(
            icon: Icon(Icons.add), onPressed: () => state.handleAddPlayerBtn()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        BackHeader(
          title: AppLocalizations.of(context)!.players,
          trailing: _buildTrailing(),
        ),
        Expanded(child: _buildUserList(context))
      ],
    ));
  }
}
