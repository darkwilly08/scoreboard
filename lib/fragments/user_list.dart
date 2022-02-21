import 'package:anotador/model/user.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:anotador/widgets/box_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerTile extends StatefulWidget {
  final User user;

  final void Function(User, bool)? onItemTapped;
  final void Function(User)? onFavoriteIconTapped;
  final bool? isTapped;

  const PlayerTile(
      {Key? key,
      required this.user,
      required this.onItemTapped,
      this.onFavoriteIconTapped,
      this.isTapped})
      : super(key: key);

  @override
  _PlayerTileState createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  bool _isSelected = false;

  Widget? _buildTrailing() {
    var onFavorite = widget.onFavoriteIconTapped;
    if (onFavorite != null) {
      return IconButton(
        icon: Icon(
          Icons.star,
          color: widget.user.favorite
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.background,
        ),
        onPressed: () => onFavorite(widget.user),
      );
    } else {
      return _isSelected
          ? Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.secondary,
            )
          : null;
    }
  }

  Card makeListTile() => Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
          child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        title: Text(
          widget.user.name,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        leading: BoxTile(
          child: Text(
            widget.user.initial,
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.background),
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
    _isSelected = widget.isTapped ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeListTile();
  }
}

class UserList extends StatefulWidget {
  final List<User>? users;
  final List<User>? preSelectedUsers;
  final void Function(User, bool)? onItemTapped;
  final void Function(User)? onFavoriteIconTapped;

  const UserList(
      {Key? key,
      this.users,
      this.preSelectedUsers,
      this.onItemTapped,
      this.onFavoriteIconTapped})
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
      for (var user in users) {
        items.add(PlayerTile(
          user: user,
          onItemTapped: widget.onItemTapped,
          onFavoriteIconTapped: widget.onFavoriteIconTapped,
          isTapped:
              widget.preSelectedUsers?.where((u) => u.id == user.id).isNotEmpty,
        ));
      }

      return ListView(
        children: items,
      );
    }

    return Center(
      child: Text(AppLocalizations.of(context)!
          .empty_list(AppLocalizations.of(context)!.players)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildUserList(context);
  }
}
