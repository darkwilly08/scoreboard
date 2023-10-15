import 'package:anotador/controllers/stats_controller.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/pages/board/constants/const_variables.dart';
import 'package:anotador/repositories/stats_repository.dart';
import 'package:anotador/routes/routes.dart';
import 'package:anotador/utils/date_helper.dart' as date_helper;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../patterns/widget_view.dart';
import '../../widgets/back_header.dart';
import 'components/header_table.dart';

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
    Navigator.pushNamed(context, Routes.filters);
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

  Widget _buildLeftHandSideColumnRow(Stats stats) {
    final leftColumns = HistoryTableConstants.columns.where((c) => c.left);
    int index = 0;
    return Row(
      children: [
        Container(
          width: leftColumns.elementAt(index++).width,
          height: HistoryTableConstants.rowHeight,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(stats.gameName),
        )
      ],
    );
  }

  Widget _buildRightHandSideColumnRow(Stats stats) {
    final rightColumns = HistoryTableConstants.columns.where((c) => !c.left);
    int index = 0;
    return Row(
      children: <Widget>[
        Container(
          width: rightColumns.elementAt(index++).width,
          height: HistoryTableConstants.rowHeight,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: stats.teamsResults
                .where((teamResult) => teamResult.me)
                .map((tr) => tr.name)
                .join('\n'),
            child: Text(
              stats.teamsResults.firstWhere((teamResult) => teamResult.me).name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Container(
          width: rightColumns.elementAt(index++).width,
          height: HistoryTableConstants.rowHeight,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            richMessage: TextSpan(
              children: stats.teamsResults
                  .where((teamResult) => !teamResult.me)
                  .mapIndexed((i, tr) => TextSpan(
                        text: "${i > 0 ? '\n' : ''}${tr.name}",
                        style: TextStyle(
                          color: tr.status.id == TeamStatus.WON
                              ? Theme.of(state.context)
                                  .colorScheme
                                  .secondaryContainer
                              : Colors.black,
                        ),
                      ))
                  .toList(),
            ),
            child: Text(
              stats.teamsResults
                  .where((teamResult) => !teamResult.me)
                  .map((tr) => tr.name)
                  .join(' '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Container(
          width: rightColumns.elementAt(index++).width,
          height: HistoryTableConstants.rowHeight,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(date_helper.DateUtils.instance
              .getFormattedDate(stats.createdAt, null, "dd/MMM/yy")),
        ),
        Container(
          width: rightColumns.elementAt(index++).width,
          height: HistoryTableConstants.rowHeight,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            stats.scoreLabel,
            style: TextStyle(
                color: stats.iWon
                    ? Theme.of(state.context).colorScheme.secondaryContainer
                    : Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(List<Stats> rawData) {
    return HorizontalDataTable(
      leftHandSideColBackgroundColor: Theme.of(state.context).backgroundColor,
      rightHandSideColBackgroundColor: Theme.of(state.context).backgroundColor,
      leftHandSideColumnWidth: HistoryTableConstants.columns
          .where((c) => c.left)
          .map((c) => c.width)
          .reduce((a, b) => a + b),
      rightHandSideColumnWidth: HistoryTableConstants.columns
          .where((c) => !c.left)
          .map((c) => c.width)
          .reduce((a, b) => a + b),
      leftSideItemBuilder: (_, index) =>
          _buildLeftHandSideColumnRow(rawData[index]),
      rightSideItemBuilder: (_, index) =>
          _buildRightHandSideColumnRow(rawData[index]),
      itemCount: rawData.length,
      headerWidgets: HeaderTable.of(state.context).build(),
      isFixedHeader: true,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<StatsController>(
          builder: (context, statsController, child) {
            if (statsController.rawTable == null) {
              return const CircularProgressIndicator();
            }

            if (statsController.rawTable!.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!
                    .empty_list(AppLocalizations.of(context)!.history)),
              );
            }

            return _buildTable(statsController.rawTable!);
          },
        ),
      ),
    );
  }
}
