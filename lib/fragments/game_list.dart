import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/patterns/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameListScreen extends StatefulWidget {
  GameListScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameListScreen> {
  late ThemeController _themeController;

  @override
  void initState() {
    _themeController = Provider.of<ThemeController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _GamesPhoneView(this);
  }
}

class _GamesPhoneView extends WidgetView<GameListScreen, _GameScreenState> {
  const _GamesPhoneView(state, {Key? key}) : super(state, key: key);

  Widget _buildGameList(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return makeListTile();
        },
        separatorBuilder: (context, index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                height: 1,
              ),
            ),
        itemCount: 2);
  }

  Widget makeListTile() => Container(
          child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        title: Text(
          "Truco",
          style: TextStyle(
              color: state._themeController.themeData.colorScheme.secondary,
              fontSize: 22.0),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "20",
                style: state._themeController.themeData.textTheme.subtitle2,
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.thumb_up_alt_outlined,
                size: 18.0,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "15",
                style: state._themeController.themeData.textTheme.subtitle2,
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.thumb_down_alt_outlined,
                size: 18.0,
              )
            ],
          ),
        ),
        trailing: FloatingActionButton(
          heroTag: null,
          elevation: 1.0,
          backgroundColor: state._themeController.themeData.colorScheme.primary,
          onPressed: () {},
          child: Icon(Icons.play_arrow,
              color: state._themeController.themeData.colorScheme.secondary),
        ),
        onTap: () {},
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildGameList(context),
    );
  }
}
