import 'package:anotador/constants/const_variables.dart';
import 'package:anotador/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BackHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const BackHeader({Key? key, required this.title, this.trailing})
      : super(key: key);

  Widget _buildTrailing() {
    return trailing ??
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Image(
              image: AssetImage(AssetsConstants.scoreboard),
              height: 38,
            ),
          ],
        );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 36.0, bottom: 0.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          _buildTrailing()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopHeader(context);
  }
}
