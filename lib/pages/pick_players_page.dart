import 'package:anotador/controllers/user_controller.dart';
import 'package:anotador/fragments/user_list.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/pages/add_user_page.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/back_header.dart';
import 'package:anotador/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PickPlayersScreen extends StatefulWidget {
  // static const String routeName = "/pickPlayers";

  final void Function(List<User>)? onConfirmSelection;
  final List<User>? unavailableUsers;
  final List<User>? preSelectedUsers;
  final bool multipleSelection;

  const PickPlayersScreen(
      {Key? key,
      required this.onConfirmSelection,
      this.unavailableUsers,
      this.preSelectedUsers,
      this.multipleSelection = true})
      : super(key: key);

  @override
  _PickPlayerscreenState createState() => _PickPlayerscreenState();
}

class _PickPlayerscreenState extends State<PickPlayersScreen> {
  final List<User> _selectedUsers = [];
  late UserController _userController;

  @override
  void initState() {
    _userController = Provider.of<UserController>(context, listen: false);

    _userController.initPlayerList();

    if (widget.preSelectedUsers != null) {
      _selectedUsers.addAll(widget.preSelectedUsers!);
    }

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
    if (widget.onConfirmSelection != null) {
      widget.onConfirmSelection!(_selectedUsers);
    }
    Navigator.pop(context);
  }

  void handlePlayerTapped(User user, bool selected) {
    setState(() {
      if (!widget.multipleSelection) _selectedUsers.clear();

      if (selected) {
        _selectedUsers.add(user);
      } else {
        _selectedUsers.removeWhere((element) => element.id == user.id);
      }
    });
  }
}

class _PickPlayersPhoneView
    extends WidgetView<PickPlayersScreen, _PickPlayerscreenState> {
  const _PickPlayersPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildUserList(BuildContext context) {
    return Consumer<UserController>(builder: (context, userController, _) {
      var players = userController.players;
      if (players == null) {
        return const CircularProgressIndicator();
      }
      return UserList(
        users: players
            .where((u) => widget.unavailableUsers == null
                ? true
                : !widget.unavailableUsers!.contains(u))
            .toList(),
        onItemTapped: state.handlePlayerTapped,
        preSelectedUsers: state._selectedUsers,
      );
    });
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(LineIcons.search),
          onPressed: () {}, // TODO: make it work
        ),
        IconButton(
          icon: const Icon(LineIcons.plus),
          onPressed: () => state.handleAddPlayerBtn(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackHeader(
          title: AppLocalizations.of(context)!.players,
          trailing: _buildTrailing(),
        ),
        body: Column(
          children: [
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
                    text: AppLocalizations.of(context)!.accept),
              ],
            )
          ],
        ));
  }
}
