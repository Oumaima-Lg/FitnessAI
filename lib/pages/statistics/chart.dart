import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

class LineChartWidget extends StatelessWidget {
  final bool isDaily;
  final List<ChartData> dailyData;
  final List<ChartData> monthlyData;
  final Color lineColor;
  final Color backgroundColor;

  const LineChartWidget({
    super.key,
    required this.isDaily,
    required this.dailyData,
    required this.monthlyData,
    this.lineColor = Colors.lightBlueAccent,
    this.backgroundColor = const Color(0xFF282A47),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        backgroundColor: backgroundColor,
        primaryXAxis: CategoryAxis(
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        series: <ChartSeries<ChartData, String>>[
          LineSeries<ChartData, String>(
            dataSource: isDaily ? dailyData : monthlyData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            color: lineColor,
            width: 3,
            markerSettings: MarkerSettings(
              isVisible: true,
              color: lineColor,
              borderWidth: 2,
              borderColor: Colors.white,
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              color: Colors.white,
              textStyle: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}