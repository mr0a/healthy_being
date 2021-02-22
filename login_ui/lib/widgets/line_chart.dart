import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineReportChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: getSpots(),
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              // colors: [kPrimaryColor],
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}

List<FlSpot> getSpots() {
  return [
    FlSpot(4, .7),
    FlSpot(5, .8),
    FlSpot(6, .7),
    FlSpot(7, .65),
    FlSpot(8, .85),
    FlSpot(9, .8),
    FlSpot(10, .72),
    FlSpot(11, .73),
    FlSpot(12, .71),
    FlSpot(13, .8),
  ];
}
