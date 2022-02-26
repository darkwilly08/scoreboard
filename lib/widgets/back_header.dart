import 'package:anotador/constants/const_variables.dart';
import 'package:flutter/material.dart';

class BackHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? leading;

  const BackHeader({Key? key, required this.title, this.trailing, this.leading})
      : super(key: key);

  Widget _buildTrailing() {
    return trailing ??
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Image(
              image: AssetImage(AssetsConstants.scoreboard),
              height: 36.0,
            ),
          ],
        );
  }

  Widget _buildLeading(BuildContext context) {
    return leading ??
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        );
  }

  Widget _buildTopHeader(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: <Widget>[
          _buildLeading(context),
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTopHeader(context);
  }
}
