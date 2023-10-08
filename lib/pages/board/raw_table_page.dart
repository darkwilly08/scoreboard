import 'dart:developer';

import 'package:anotador/controllers/stats_controller.dart';
import 'package:anotador/repositories/stats_repository.dart';
import 'package:anotador/utils/date_helper.dart' as date_helper;
import 'package:anotador/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../patterns/widget_view.dart';
import '../../widgets/back_header.dart';

class RawTablePage extends StatefulWidget {
  static const String routeName = '/RawTablePage';

  const RawTablePage({Key? key}) : super(key: key);

  @override
  State<RawTablePage> createState() => _RawTablePageState();
}

class _RawTablePageState extends State<RawTablePage> {
  late StatsController _statsController;

  @override
  void initState() {
    super.initState();
    _statsController = Provider.of<StatsController>(context, listen: false);

    _statsController.getRawTable();
  }

  @override
  Widget build(BuildContext context) {
    return _RawTablePagePhoneView(this);
  }

  void handleFilterBtn() {
    final snackBar = SuccessSnackBar(
      Text(AppLocalizations.of(context)!.comingSoon),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }
}

class _RawTablePagePhoneView
    extends WidgetView<RawTablePage, _RawTablePageState> {
  const _RawTablePagePhoneView(_RawTablePageState state, {Key? key})
      : super(state, key: key);

  Widget? _buildTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(LineIcons.filter),
          onPressed: () => state.handleFilterBtn(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackHeader(
          title: AppLocalizations.of(context)!.history,
          trailing: _buildTrailing(),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<StatsController>(
              builder: (context, statsController, child) {
                return _buildTable(statsController.rawTable);
              },
            )));
  }

  Widget _generateFirstColumnRow(Stats stats) {
    return Container(
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(stats.gameName),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget(
          AppLocalizations.of(state.context)!.table_header_game, 75),
      _getTitleItemWidget(
          AppLocalizations.of(state.context)!.table_header_opponent, 100),
      _getTitleItemWidget(
          AppLocalizations.of(state.context)!.table_header_date, 100),
      _getTitleItemWidget(
          AppLocalizations.of(state.context)!.table_header_score, 75),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(state.context).colorScheme.secondaryContainer)),
    );
  }

  Widget _buildTable(List<Stats>? rawData) {
    if (rawData == null || rawData.isEmpty) {
      return const CircularProgressIndicator();
    }

    inspect(rawData);

    return HorizontalDataTable(
      leftHandSideColBackgroundColor: Theme.of(state.context).backgroundColor,
      rightHandSideColBackgroundColor: Theme.of(state.context).backgroundColor,
      leftHandSideColumnWidth: 75,
      rightHandSideColumnWidth: 275,
      leftSideItemBuilder: (_, index) =>
          _generateFirstColumnRow(rawData[index]),
      rightSideItemBuilder: (_, index) =>
          _generateRightHandSideColumnRow(rawData[index]),
      itemCount: rawData.length,
      headerWidgets: _getTitleWidget(),
      isFixedHeader: true,
    );
  }

  Widget _generateRightHandSideColumnRow(Stats stats) {
    return Row(
      children: <Widget>[
        Container(
            width: 100,
            height: 52,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(stats.scoreSummarized?.opponentName ?? "")),
        Container(
          width: 100,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(date_helper.DateUtils.instance
              .getFormattedDate(stats.createdAt, null, "dd/MMM/yy")),
        ),
        Container(
          width: 75,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            stats.scoreSummarized?.scoreLabel ?? "",
            style: TextStyle(
                color: stats.iWon
                    ? Theme.of(state.context).colorScheme.secondaryContainer
                    : Colors.red),
          ),
        ),
      ],
    );
  }
}
