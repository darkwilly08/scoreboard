import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/controllers/locale_controller.dart';
import 'package:anotador/controllers/theme_controller.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 36.0, bottom: 0.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
            iconSize: 32.0,
            padding: const EdgeInsets.all(0),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Image(
                image: AssetImage(AssetsConstants.scoreboard),
                height: 38,
              ),
              // SizedBox(width: 8), // give it width
              // Image(image: AssetImage("assets/images/icon-qm-iot.png"), height: 40,),
            ],
          )
        ],
      ),
    );
  }

  void _drawerItemClicked(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        drawer: AppDrawer(
          onItemClicked: (route) => _drawerItemClicked(context, route),
        ),
        body:
            // Stack(children: [
            //   Container(
            //     decoration: const BoxDecoration(
            //       image: DecorationImage(image: AssetImage("assets/images/main-bg.jpg"), fit: BoxFit.cover,),
            //     ),
            //   ),
            Column(
          children: [
            Builder(builder: (context) => _buildTopHeader(context)),
            ElevatedButton(
              onPressed: () async =>
                  await Provider.of<ThemeController>(context, listen: false)
                      .changeMode(false),
              child: const Text("toggle theme"),
            ),
            ElevatedButton(
              onPressed: () async =>
                  await Provider.of<LocaleController>(context, listen: false)
                      .changeLanguage('es'),
              child: const Text("toggle language"),
            ),
          ],
        )
        // ],),
        );
  }
}
