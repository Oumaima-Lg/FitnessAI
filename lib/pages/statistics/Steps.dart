import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/statistics/chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {

  final String iconPath = 'images/statistics/steps.png'; // <-- ton image ici
    bool isDaily = false;
  List<ChartData> monthlyData = [];
  List<ChartData> dailyData = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
  final uid = currentUserId;
  if (uid == null) return;

  final now = DateTime.now();
  final firestore = FirebaseFirestore.instance;

  try {
    // 1. Données journalières (7 derniers jours)
    final dailyStatsQuery = await firestore
        .collection('users')
        .doc(uid)
        .collection('dailyStats')
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    final dailyList = dailyStatsQuery.docs
        .map((doc) {
          final data = doc.data();
          final date = DateTime.parse(data['date']);
          final steps = data['steps'] ?? 0;
          final dayLabel = DateFormat.E().format(date); // Mon, Tue, ...
          return ChartData(dayLabel, steps);
        })
        .toList()
        .reversed
        .toList(); // Pour afficher du plus ancien au plus récent

    // 2. Données mensuelles (30 derniers jours, groupées par mois)
    final last30DaysQuery = await firestore
        .collection('users')
        .doc(uid)
        .collection('dailyStats')
        .orderBy('date', descending: true)
        .limit(30)
        .get();

    final Map<String, int> monthTotals = {}; // ex: {"Jun": 12300}
    for (final doc in last30DaysQuery.docs) {
      final data = doc.data();
      final date = DateTime.parse(data['date']);
      final steps = (data['steps'] ?? 0);
      final month = DateFormat.MMM().format(date); // Jun, Jul...

      monthTotals[month] = (monthTotals[month] ?? 0) + (steps is int ? steps : (steps as num).toInt());
    }

    final monthList = monthTotals.entries
        .map((e) => ChartData(e.key, e.value as double))
        .toList();

    setState(() {
      dailyData = dailyList;
      monthlyData = monthList;
    });
  } catch (e) {
    print('Erreur de chargement des données Firestore : $e');
  }
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
