import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineCharts extends StatelessWidget {
  final maxValue = 10;
  @override
  Widget build(BuildContext context) {
    const cutOffYValue = 0.0;
    final yearTextStyle = GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
    );

    return Container(
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 0),
                FlSpot(1, 1),
                FlSpot(2, 3),
                FlSpot(3, 3),
                FlSpot(4, 5),
                FlSpot(4, 6),
                FlSpot(5, 6),
                FlSpot(6, 7),
              ],
              isCurved: true,
              barWidth: 2,
              colors: [
                Colors.black,
              ],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.lightGreen.withOpacity(0.4)],
                cutOffY: cutOffYValue,
                applyCutOffY: true,
              ),
              aboveBarData: BarAreaData(
                show: true,
                colors: [Colors.red.withOpacity(0.6)],
                cutOffY: cutOffYValue,
                applyCutOffY: true,
              ),
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 7,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return '5th';
                    case 1:
                      return '6th';
                    case 2:
                      return '7th';
                    case 3:
                      return '8th';
                    case 4:
                      return '9th';
                    case 5:
                      return '10th';
                    case 6:
                      return '11th';
                    default:
                      return '';
                  }
                }),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                return '$value';
              },
            ),
          ),
          axisTitleData: FlAxisTitleData(
              leftTitle: AxisTitle(
                showTitle: true,
                titleText: 'Questions',
                margin: 10,
                textStyle: yearTextStyle,
              ),
              bottomTitle: AxisTitle(
                  showTitle: true,
                  margin: 20,
                  titleText: 'Date',
                  textStyle: yearTextStyle,
                  textAlign: TextAlign.right)),
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (double value) {
              return true;
            },
          ),
        ),
      ),
    );
  }
}
