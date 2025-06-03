import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/models/userStats.dart'; // Ajout de l'import
import 'package:fitness/firebase_service.dart'; // Import your Firebase service

class GoalTrack extends StatefulWidget {
  final int maxLevel;
  final UserStats stats;
  
  GoalTrack({Key? key, this.maxLevel = 10, UserStats? stats})
      : stats = stats ?? UserStats(),
        super(key: key); // Correction de la syntaxe du constructeur

  @override
  State<GoalTrack> createState() => _GoalTrackState();
}

class _GoalTrackState extends State<GoalTrack> {
  late int currentWaterLevel;

  @override
  void initState() {
    super.initState();
    currentWaterLevel = 0;
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = 300;
    return Scaffold(
      backgroundColor: const Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'GoalTrack',
          style: titleTextStyle(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.maxLevel} Glass\nWater',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                // Graduation numbers
                Column(
                  children: List.generate(widget.maxLevel, (index) {
                    int number = widget.maxLevel - index;
                    return Container(
                      width: 50,
                      height: containerHeight / widget.maxLevel,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$number',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  }),
                ),
                // Water container
                Container(
                  width: 100,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: (currentWaterLevel / widget.maxLevel) * containerHeight,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow indicator
                Positioned(
                  right: 0,
                  top: (widget.maxLevel - currentWaterLevel) *
                          (containerHeight / widget.maxLevel) -
                      15,
                  child: const Icon(Icons.arrow_left, size: 30, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Number of drinks : $currentWaterLevel',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {  // Ajout du async
                setState(() {
                  if (currentWaterLevel < widget.maxLevel) {
                    currentWaterLevel += 1;
                  }
                });
                widget.stats.water = currentWaterLevel.toDouble(); // Modification pour suivre l'eau
                await saveDailyStats(widget.stats);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Données d\'hydratation sauvegardées')),
                );
              },
              child: const Text('+'),
            ),
          ],
        ),
      ),
    );
  }
}
