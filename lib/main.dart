import 'package:flutter/material.dart';
import 'pages/exercice_page.dart';

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
      home: ExercicePage(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => ExercicePage(),
      //   '/jumping_jack': (context) => JumpingJackPage(),
      //   '/wall_sit': (context) => WallSit(),
      //   '/push_ups': (context) => PushUps(),
      //   '/crunches': (context) => Crunches(),
      //   '/steps_ups': (context) => StepsUps(),
      //   '/squats': (context) => Squats(),
      //   '/tricep_dips_using_a_chair': (context) => TricepDipsUsingAChair(),
      //   '/plank': (context) => Plank(),
      //   '/high_knees': (context) => HighKnees(),
      //   '/forward_lunges': (context) => ForwardLunges(),
      //   '/t_push_ups': (context) => TPushUps(),
      //   '/side_plank': (context) => SidePlank(),
      // },
    );
  }
}
