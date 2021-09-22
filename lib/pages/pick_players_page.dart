import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/fragments/user_list.dart';
import 'package:anotador/model/User.dart';
import 'package:anotador/pages/add_user_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PickPlayersScreen extends StatefulWidget {
  // static const String routeName = "/pickPlayers";

  final void Function()? onPlayerClicked;

  const PickPlayersScreen({Key? key, required this.onPlayerClicked})
      : super(key: key);

  @override
  _PickPlayerscreenState createState() => _PickPlayerscreenState();
}

class _PickPlayerscreenState extends State<PickPlayersScreen> {
  List<User> _selectedUsers = [];
  late UserController _userController;

  @override
  void initState() {
    _userController = Provider.of<UserController>(context, listen: false);

    _userController.initPlayerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _PickPlayersPhoneView(this);
  }

  void handleAddPlayerBtn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddUserScreen()));
  }

  void handleCancelBtn() {
    Navigator.pop(context);
  }

  void handleAcceptBtn() {
    print(_selectedUsers.toString());
  }

  void handlePlayerTapped(User user, bool selected) {
    if (selected) {
      _selectedUsers.add(user);
    } else {
      _selectedUsers.removeWhere((element) => element.id == user.id);
    }
  }
}

class _PickPlayersPhoneView
    extends WidgetView<PickPlayersScreen, _PickPlayerscreenState> {
  const _PickPlayersPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildUserList(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, _) {
      var players = userController.players;
      if (players == null) {
        return CircularProgressIndicator();
      }

      return UserList(
        users: players,
        onItemTapped: state.handlePlayerTapped,
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
        Expanded(child: _buildUserList(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomTextButton(
                onTap: () => state.handleCancelBtn(),
                text: AppLocalizations.of(context)!.cancel),
            CustomTextButton(
                onTap: () {
                  state.handleAcceptBtn();
                },
                text: AppLocalizations.of(context)!.save),
          ],
        )
      ],
    ));
  }
}
