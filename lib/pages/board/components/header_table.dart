import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/const_variables.dart';

class HeaderTable {
  final double height;
  final BuildContext context;

  HeaderTable(this.context, {required this.height});

  static HeaderTable of(BuildContext context, {double? height}) {
    return HeaderTable(context,
        height: height ?? HistoryTableConstants.rowHeight);
  }

  Widget _getHeaderItemWidget(String label, double width) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondaryContainer)),
    );
  }

  List<Widget> build() {
    final columns = HistoryTableConstants.columns;
    int index = 0;
    return [
      _getHeaderItemWidget(AppLocalizations.of(context)!.table_header_game,
          columns.elementAt(index++).width),
      _getHeaderItemWidget(AppLocalizations.of(context)!.table_header_my_team,
          columns.elementAt(index++).width),
      _getHeaderItemWidget(AppLocalizations.of(context)!.table_header_opponent,
          columns.elementAt(index++).width),
      _getHeaderItemWidget(AppLocalizations.of(context)!.table_header_date,
          columns.elementAt(index++).width),
      _getHeaderItemWidget(AppLocalizations.of(context)!.table_header_score,
          columns.elementAt(index++).width),
    ];
  }
}
