import 'package:flutter/material.dart';
import 'pages/exercice_page.dart';
import '../Hiit/crunches.dart';
import '../Hiit/forward_lunges.dart';
import '../Hiit/high_knees.dart';
import '../Hiit/plank.dart';
import '../Hiit/push_ups.dart';
import '../Hiit/side_plank.dart';
import '../Hiit/squats.dart';
import '../Hiit/steps_ups.dart';
import '../Hiit/t_push_ups.dart';
import '../Hiit/tricep_dips_using_a_chair.dart';
import '../Hiit/jumping_jack_page.dart';
import '../Hiit/wall_sit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ExercicePage(),
        '/jumping_jack': (context) => JumpingJackPage(), 
        '/wall_sit': (context) => WallSit(), 
        '/push_ups': (context) => PushUps(), 
        '/crunches': (context) => Crunches(), 
        '/steps_ups': (context) => StepsUps(), 
        '/squats': (context) => Squats(), 
        '/tricep_dips_using_a_chair': (context) => TricepDipsUsingAChair(), 
        '/plank': (context) => Plank(), 
        '/high_knees': (context) => HighKnees(), 
        '/forward_lunges': (context) => ForwardLunges(), 
        '/t_push_ups': (context) => TPushUps(), 
        '/side_plank': (context) => SidePlank(), 
      },
    );
  }

}
