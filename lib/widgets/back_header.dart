import 'package:anotador/constants/const_variables.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final Widget? leading;

  const BackHeader({Key? key, required this.title, this.trailing, this.leading})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  Widget _buildTrailing() {
    return trailing ??
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Image(
                image: AssetImage(AssetsConstants.scoreboard),
                height: 36.0,
              ),
            ],
          ),
        );
  }

  Widget _buildLeading(BuildContext context) {
    Widget child = leading ??
        IconButton(
          icon: const Icon(LineIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: child,
    );
  }

  PreferredSizeWidget _buildTopHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: _buildLeading(context),
      centerTitle: false,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: [_buildTrailing()],
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return _buildTopHeader(context);
  }
}
