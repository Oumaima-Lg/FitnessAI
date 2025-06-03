import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitness/pages/statistics/chart.dart';
import 'package:fitness/components/textStyle/textstyle.dart';

class SleepStatsWidget extends StatefulWidget {
  const SleepStatsWidget({super.key});

  @override
  State<SleepStatsWidget> createState() => _SleepStatsWidgetState();
}

class _SleepStatsWidgetState extends State<SleepStatsWidget> {
  List<ChartData> monthlyData = [];
  List<ChartData> dailyData = [];
  double progress = 0;
  double monthlyChange = 0;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    // Simuler le chargement des données
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      monthlyData = [
        ChartData('May', 45),
        ChartData('Jun', 80),
        ChartData('Jul', 25),
        ChartData('Aug', 60),
        ChartData('Sep', 90),
      ];
      
      dailyData = [
        ChartData('Mon', 20),
        ChartData('Tue', 45),
        ChartData('Wed', 30),
        ChartData('Thu', 60),
        ChartData('Fri', 10),
        ChartData('Sat', 75),
        ChartData('Sun', 40),
      ];
   
      progress = calculateSleepProgress(monthlyData);
      monthlyChange = calculateMonthlyChange(monthlyData);
    });
  }

  double calculateSleepProgress(List<ChartData> data) {
    if (data.isEmpty) return 0;
    return (data.last.y / 100.0 * 100).clamp(0, 100);
  }

  double calculateMonthlyChange(List<ChartData> data) {
    if (data.length < 2) return 0;
    final current = data[data.length - 1].y;
    final previous = data[data.length - 2].y;
    return ((current - previous) / previous) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = monthlyChange >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Color(0xFF121330),
      appBar: AppBar(
      backgroundColor: Color(0xFF121330),      centerTitle: true,
      title: Text(
        'Sleep Analytics',
        style: titleTextStyle(),
      ),
    ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Based on our data ',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color:Color(0xFF8189B0)
                  ),
                ),
              // Progress circle card
              Container(
                
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF8A7FFA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "You almost\nReach a perfect\nmonth of sleep",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 8.0,
                      percent: progress / 100.0,
                      center: Text("${progress.toStringAsFixed(0)}%",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      progressColor: Colors.white,
                      backgroundColor: Colors.white24,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              
              // Sleep Overview text
              Text(
                "Sleep Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              
              SizedBox(height: 15),

              // Monthly change card
              Container(
                width: 160,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1F3D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "Monthly Change",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${monthlyChange >= 0 ? "+" : ""}${monthlyChange.toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Fake curve - replace with real chart lib if needed
                    Icon(
                      isPositive ? Icons.show_chart : Icons.stacked_line_chart,
                      color: color,
                      size: 40,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              Text(
                "Weekly Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              // Chart
              Container(
                  child: (monthlyData.isNotEmpty && dailyData.isNotEmpty)
                    ? LineChartWidget(
                        isDaily: true,
                        dailyData: dailyData,
                        monthlyData: monthlyData,
                      )
                    : const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
