import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          axisNameWidget: Text('Won/Lost trends'),
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  List<LineChartBarData> get lineBarsData1 =>
      [lineChartBarData1_1, lineChartBarData1_2];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0xFF03DAC5),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Color.fromARGB(255, 246, 74, 226),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.transparent),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ListView list = ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              height: 300,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: lineTouchData1,
                        gridData: gridData,
                        titlesData: titlesData1,
                        borderData: borderData,
                        lineBarsData: lineBarsData1,
                        minX: 0,
                        maxX: 14,
                        maxY: 4,
                        minY: 0,
                      ),
                    )),
              )),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              height: 300,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: BarChart(
                      BarChartData(
                        maxY: 20,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (a, b, c, d) => null,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            axisNameWidget: Text('Results by opponent'),
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: barChartbottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: barChartleftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: [
                          makeGroupData(0, 5, 12),
                          makeGroupData(1, 16, 12),
                          makeGroupData(2, 18, 5),
                          makeGroupData(3, 20, 16),
                          makeGroupData(4, 17, 6),
                          makeGroupData(5, 19, 1.5),
                          makeGroupData(6, 10, 1.5)
                        ],
                        gridData: FlGridData(show: false),
                      ),
                      swapAnimationDuration:
                          Duration(milliseconds: 150), // Optional
                      swapAnimationCurve: Curves.linear, // Optional
                    )),
              )),
        ),
      ],
    );

    return Stack(
      children: [
        Container(child: list),
      ],
    );
  }

  Widget barChartbottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Bar', 'Sol', 'Mar', 'Lu', 'Jua', 'Ba/Lu', 'Ago'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  Widget barChartleftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF03DAC5),
          width: 7,
        ),
        BarChartRodData(
          toY: y2,
          color: const Color.fromARGB(255, 246, 74, 226),
          width: 7,
        ),
      ],
    );
  }
}
