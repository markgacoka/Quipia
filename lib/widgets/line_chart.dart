import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartPage extends StatefulWidget {
  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  int _percentileInt, userPoints, rank, index, percentile;
  List _pointsArr;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final List<double> oneten = [
    0.000,
    2.060,
    4.430,
    6.720,
    8.390,
    9.010,
    8.391,
    6.721,
    4.431,
    2.061,
    0.001
  ];

  @override
  void initState() {
    super.initState();
    _getPercentileInt();
  }

  _getPercentileInt() async {
    _percentileInt = await _getPercentile();
    setState(() {
      _percentileInt = _percentileInt;
    });
  }

  Future<int> _getPercentile() async {
    _pointsArr = await _getPoints();
    List<int> dataListAsInt =
        _pointsArr.map((data) => int.parse(data)).toList();
    userPoints = int.parse(await _getPointsDB());
    rank = dataListAsInt.indexOf(userPoints) + 1;
    index = 100 ~/ dataListAsInt.length;
    percentile = (index * rank).toInt();
    return percentile ~/ 10;
  }

  Future<List> _getPoints() async {
    var documents = await FirebaseFirestore.instance
        .collection('points')
        .orderBy("points", descending: false)
        .get();
    return documents.docs.map((e) => e.data()['points']).toList();
  }

  Future<String> _getPointsDB() async {
    String currPoints;
    final String userUID = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('points')
        .where(FieldPath.documentId, isEqualTo: userUID)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> pointsData = event.docs.single.data();
        currPoints = pointsData['points'];
      }
    }).catchError((e) => print("error fetching data: $e"));
    return currPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(color: Color(0xff232d37)),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    final List<FlSpot> _values = oneten
        .map(
            (minilist) => FlSpot(oneten.indexOf(minilist).toDouble(), minilist))
        .toList();

    final yearTextStyle = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: _values,
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              if (spot.x != _percentileInt) {
                return false;
              }
              return true;
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot((_percentileInt == null) ? 5.0 : _percentileInt.toDouble(),
                0.0),
            FlSpot((_percentileInt == null) ? 5.0 : _percentileInt.toDouble(),
                (_percentileInt == null) ? 9.010 : oneten[_percentileInt]),
          ],
          barWidth: 2,
          isCurved: false,
        ),
      ],
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTextStyles: (value) =>
              const TextStyle(color: Color(0xff68737d), fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0th';
              case 1:
                return '10th';
              case 2:
                return '20th';
              case 3:
                return '30th';
              case 4:
                return '40th';
              case 5:
                return '50th';
              case 6:
                return '60th';
              case 7:
                return '70th';
              case 8:
                return '80th';
              case 9:
                return '90th';
              case 10:
                return '99th';
              default:
                return '';
            }
          },
          margin: 15,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => yearTextStyle,
          getTitles: (value) {
            return '$value';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(
            showTitle: true,
            titleText: 'Density of users',
            margin: 10,
            textStyle: yearTextStyle,
          ),
          bottomTitle: AxisTitle(
              showTitle: true,
              margin: 16,
              titleText: 'Cumulative percentile',
              textStyle: yearTextStyle,
              textAlign: TextAlign.right)),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minY: 0,
    );
  }
}
