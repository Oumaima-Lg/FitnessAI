import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/statistics/chart.dart';

class Training extends StatefulWidget {
  const Training({super.key});

  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {

  final String iconPath = 'images/statistics/training.png'; // <-- ton image ici
    bool isDaily = false;
  List<ChartData> monthlyData = [];
  List<ChartData> dailyData = [];

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
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2F55),
        centerTitle: true,
        title: Text('Statistics', style: titleTextStyle()),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
            const SizedBox(height: 18),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                  'images/statistics/Base.png',
                  fit: BoxFit.cover,
                ),
                // Ton conteneur avec l'icône image
                Positioned(
                  top: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF282A47).withAlpha((0.56 * 255).toInt()),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        iconPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Switch Daily/Monthly
                Positioned(
                  top: 120,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleButton('Daily', isDaily),
                        _buildToggleButton('Monthly', !isDaily),
                      ],
                    ),
                  ),
                ),
                // Graphique
                Positioned(
                  top: 200, // Adjust this value as needed
                  child: (monthlyData.isNotEmpty && dailyData.isNotEmpty)
                    ? LineChartWidget(
                        isDaily: isDaily,
                        dailyData: dailyData,
                        monthlyData: monthlyData,
                      )
                    : const CircularProgressIndicator(),
                ),
               
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() {
        isDaily = (label == 'Daily');
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? Colors.lightBlueAccent.withOpacity(0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
