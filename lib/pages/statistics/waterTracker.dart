import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/statistics/goalPage.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  final TextEditingController _controller = TextEditingController();
  String _unit = 'Number of glass';
  int? _selectedGlasses;
  int? finalGlassValue;
  int? savedGoalValue;
  bool _showGrid = false;

  final List<Map<String, dynamic>> goals = [
    {'title': 'Summer time', 'glasses': 10, 'emoji': '☀️'},
    {'title': 'Workout Day', 'glasses': 10, 'emoji': '🏋️‍♂️'},
    {'title': 'Snow day', 'glasses': 5, 'emoji': '❄️'},
    {'title': 'Sporty', 'glasses': 7, 'emoji': '🏀'},
    {'title': 'Lazy Day', 'glasses': 5, 'emoji': '🛏️'},
    {'title': 'Travel Day', 'glasses': 8, 'emoji': '✈️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2F55),
      appBar: AppBar(
          backgroundColor: const Color(0xFF2E2F55),
          centerTitle: true,
          title: Text('Water Tracker', style: titleTextStyle()),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          children: [
            SizedBox(height: 10),
            Text('Please enter your goals or Select it.', style: titleTextStyle()),
            SizedBox(height: 20),

            /// Input Field
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your goal',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  finalGlassValue = int.tryParse(value);
                });
              },
            ),

            SizedBox(height: 10),

            /// Dropdown for Unit
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _unit,
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                underline: SizedBox(),
                items: ['Number of glass', 'Liters'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),
            ),

            SizedBox(height: 30),

            /// Section Title
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GradientComponent.gradientButton(
                text: 'Select your goal',
                maxWidth: 315,
                maxHeight: 50,
                onPressed: () {
                  setState(() {
                    _showGrid = true;
                  });
                },
              ),
            ),

            SizedBox(height: 20),

            if (_showGrid) ...[
              Stack(
                children: [
                  // La grille existante
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3, // Augmenter le nombre d'éléments par ligne
                    mainAxisSpacing: 8, // Réduire l'espacement vertical
                    crossAxisSpacing: 8, // Réduire l'espacement horizontal
                    childAspectRatio: 1.2, // Ajuster le ratio hauteur/largeur des éléments
                    physics: NeverScrollableScrollPhysics(),
                    children: goals.map((goal) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGlasses = goal['glasses'];
                            _controller.text = _selectedGlasses.toString();
                            finalGlassValue = _selectedGlasses;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade200,
                            borderRadius: BorderRadius.circular(12), // Réduire le radius
                          ),
                          padding: EdgeInsets.all(8), // Réduire le padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal['title'], 
                                style: TextStyle(fontSize: 12, color: Colors.black) // Réduire la taille du texte
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${goal['glasses']} Glass',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                  Text(goal['emoji'], style: TextStyle(fontSize: 24)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Bouton de fermeture
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                      setState(() {
                          _showGrid = false;
                        });
 
                      },
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Pour que la Column ne prenne que l'espace nécessaire
                children: [
                  // Premier bouton
                  GradientComponent.gradientButton(
                    text: 'validate your goal',
                    maxWidth: 315,
                    maxHeight: 50,
                    onPressed: () {
                      setState(() {
                        _showGrid = false;
                        // Sauvegarder la valeur finale
                        savedGoalValue = finalGlassValue;
                        // Afficher un message de confirmation (optionnel)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Goal saved: ${savedGoalValue.toString()} glasses'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                      });
                    },
                  ),
                  
                  const SizedBox(height: 10), // Espacement entre les boutons
                  
                  // Deuxième bouton
                  GradientComponent.gradientButton(
                    text: 'See your goal Preview',
                    maxWidth: 315,
                    maxHeight: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalTrack(
                            waterLevel: savedGoalValue ?? finalGlassValue ?? 0,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
