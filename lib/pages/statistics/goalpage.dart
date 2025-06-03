import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';

class GoalTrack extends StatefulWidget {
  final int waterLevel;
  
  const GoalTrack({Key? key, required this.waterLevel}) : super(key: key);

  @override
  State<GoalTrack> createState() => _GoalTrackState();
}

class _GoalTrackState extends State<GoalTrack> {
  late int currentWaterLevel;

  @override
  void initState() {
    super.initState();
    currentWaterLevel = widget.waterLevel;
  }

  @override
  Widget build(BuildContext context) {
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
              '6 Glass\nWater',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              )
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                // La jauge avec les nombres
                Column(
                  children: List.generate(10, (index) {
                    int number = 10 - index;
                    return Container(
                      width: 50,
                      height: 30,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      ),
                    );
                  }),
                ),
                // Le verre d'eau
                Container(
                  width: 100,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: (currentWaterLevel / 10) * 300,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                // La flèche
                Positioned(
                  right: 0,
                  top: (10 - currentWaterLevel) * 30 - 15,
                  child: const Icon(
                    Icons.arrow_left, 
                    size: 30, 
                    color: Colors.red
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Niveau actuel: $currentWaterLevel',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentWaterLevel = currentWaterLevel == 10 ? 1 : currentWaterLevel + 1;
                });
              },
              child: const Text('Changer le niveau'),
            ),
          ],
        ),
      ),
    );
  }
}