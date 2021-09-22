import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/model/User.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/box_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatefulWidget {
  final User user;

  final void Function(User, bool)? onItemTapped;
  final void Function(User)? onFavoriteIconTapped;

  PlayerTile(
      {Key? key,
      required this.user,
      required this.onItemTapped,
      this.onFavoriteIconTapped})
      : super(key: key);

  @override
  _PlayerTileState createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  late ThemeController _themeController;
  bool _isSelected = false;

  Widget? _buildTrailing() {
    var onFavorite = widget.onFavoriteIconTapped;
    if (onFavorite != null) {
      return IconButton(
        icon: Icon(
          Icons.star,
          color: widget.user.favorite
              ? _themeController.themeData.colorScheme.secondary
              : _themeController.themeData.colorScheme.primaryVariant,
        ),
        onPressed: () => onFavorite(widget.user),
      );
    } else {
      return _isSelected
          ? Icon(
              Icons.check,
              color: _themeController.themeData.colorScheme.secondary,
            )
          : null;
    }
  }

  Card makeListTile() => Card(
      elevation: 4.0,
      margin: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
          child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          widget.user.name,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        leading: BoxTile(
          child: Text(
            widget.user.initial,
            style: TextStyle(
                fontSize: 20,
                color: _themeController.themeData.colorScheme.primary),
          ),
        ),
        trailing: _buildTrailing(),
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });

          if (widget.onItemTapped != null) {
            widget.onItemTapped!(widget.user, _isSelected);
          }
        },
      )));

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeListTile();
  }
}

class UserList extends StatefulWidget {
  final List<User>? users;
  final void Function(User, bool)? onItemTapped;
  final void Function(User)? onFavoriteIconTapped;

  UserList({Key? key, this.users, this.onItemTapped, this.onFavoriteIconTapped})
      : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return _UserListView(this);
  }
}

class _UserListView extends WidgetView<UserList, _UserListState> {
  const _UserListView(state, {Key? key}) : super(state, key: key);

  Widget _buildUserList(BuildContext context) {
    List<Widget> items = [];
    var users = widget.users;
    if (users != null && users.isNotEmpty) {
      users.forEach((user) {
        items.add(PlayerTile(
          user: user,
          onItemTapped: widget.onItemTapped,
          onFavoriteIconTapped: widget.onFavoriteIconTapped,
        ));
      });

      return ListView(
        children: items,
      );
    }

    return Text("data");
  }

  @override
  Widget build(BuildContext context) {
    return _buildUserList(context);
  }
}
