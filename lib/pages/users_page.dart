import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/fragments/user_list.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/pages/add_user_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
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
  late UserController _userController;

  @override
  void initState() {
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

  void handleEditPlayerTap(User user, bool _) {
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
}

class _UsersPhoneView extends WidgetView<UsersScreen, _UserscreenState> {
  const _UsersPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildUserList(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, _) {
      var players = userController.players;
      if (players == null) {
        return CircularProgressIndicator();
      }

      return UserList(
        users: players,
        onItemTapped: state.handleEditPlayerTap,
        onFavoriteIconTapped: state.handleToggleFavorite,
      );
    });
  }

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
