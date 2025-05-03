import 'package:fitness/data/exercice_data.dart';
import 'package:fitness/entrainements/hiit.dart';
import 'package:fitness/models/activity.dart';
import 'package:fitness/models/exercice.dart';
import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class ExercicePage extends StatefulWidget {
  ExercicePage({
    super.key,
  });

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  final List<Map<String, String>> activities = [
    {
      'name': 'Jumping Jack',
      'image': 'Jumping Jack/1.png',
      'route': '/jumping_jack'
    },
    {'name': 'Wall Sit', 'image': 'Wall Sit/img2.png', 'route': '/wall_sit'},
    {'name': 'Push-Ups', 'image': 'img3.png', 'route': '/push_ups'},
    {'name': 'Crunches', 'image': 'img4.png', 'route': '/crunches'},
    {
      'name': 'Step-Ups onto a Chair',
      'image': 'img5.png',
      'route': '/steps_ups'
    },
    {'name': 'Squats', 'image': 'img6.png', 'route': '/squats'},
    {
      'name': 'Tricep Dips Using a Chair',
      'image': 'img7.png',
      'route': '/tricep_dips_using_a_chair'
    },
    {'name': 'Plank', 'image': 'img8.png', 'route': '/plank'},
    {'name': 'High Knees', 'image': 'img9.png', 'route': '/high_knees'},
    {
      'name': 'Forward Lunges',
      'image': 'img10.png',
      'route': '/forward_lunges'
    },
    {'name': 'T-Push-Ups', 'image': 'img11.png', 'route': '/t_push_ups'},
    {'name': 'Side Plank', 'image': 'img12.png', 'route': '/side_plank'},
  ];

  final List<Map<String, String>> exerciseTypes = [
    {'title': 'HIIT', 'image': 'HIIT'},
    {'title': 'Cardio', 'image': 'Cardio'},
    {'title': 'Gym', 'image': 'Gym'},
    {'title': 'Recovery', 'image': 'recovery'},
  ];

  List<Exercice> exercices = [];
  int currentIndex = 0;
  int track = 0;

  @override
  void initState() {
    super.initState();
    exercices = ExerciceData.getExercices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                'Fitness Exercises &\n Activities',
                style: titleTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: exercices
                      .map((exercise) => Row(
                            children: [
                              ExerciceType(
                                title: exercise.title,
                                imageName: exercise.imageUrl,
                                exerciceIndex: int.parse(exercise.id) - 1,
                              ),
                              SizedBox(width: 30),
                            ],
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 40),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Etoile(),
                      GradientTitleText(
                        text: 'HIIT',
                        alignment: Alignment.center,
                        fontSize: 20,
                      ),
                      Etoile(),
                    ],
                  ),
                  SizedBox(height: 10),
                  GradientTitleText(
                    text: 'High-Intensity Interval Training',
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 20),
                  Image(
                    image: AssetImage('images/icons/HIIT.png'),
                    width: 110,
                    height: 110,
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Activities',
                      style: titleTextStyle(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.separated(
                    itemCount: activities.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      var activities = exercices[0].activities;
                      final activity = activities[index];
                      return ActivityButton(
                        activityName: activity.title,
                        imageName: activity.iconUrl,
                        activity: activity,
                        // routeName: activity['route'] ?? '/jumping_jack',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget ExerciceType(String title, String imageName, int exerciceIndex) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         track = exerciceIndex;
  //       });
  //     },
  //     child: Container(
  //       width: 115,
  //       height: 112,
  //       decoration: BoxDecoration(
  //         color: exerciceTypeSelected ? null : Color(0xFF2E2F55),
  //         gradient: exerciceTypeSelected
  //             ? LinearGradient(
  //                 colors: [Color(0xFFFFA992), Color(0xFFFD0D92)],
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //               )
  //             : null,
  //         border: Border.all(color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
  //         borderRadius: BorderRadius.circular(24),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10),
  //         child: Column(
  //           children: [
  //             Text(
  //               widget.title,
  //               style: titleTextStyle(color: Color(0xFFE9E3E4), fontSize: 15),
  //             ),
  //             SizedBox(height: 10),
  //             Image.asset(
  //               // 'images/icons/${widget.imageName}.png',
  //               widget.imageName,
  //               width: 51,
  //               height: 51,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class Etoile extends StatelessWidget {
  const Etoile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '★',
      style: TextStyle(
        color: Color(0xFFFFA992),
        fontSize: 20,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ExerciceType extends StatefulWidget {
  final String title;
  final String imageName;
  final int exerciceIndex;

  const ExerciceType({
    super.key,
    required this.title,
    required this.imageName,
    required this.exerciceIndex,
  });

  @override
  State<ExerciceType> createState() => _ExerciceTypeState();
}

class _ExerciceTypeState extends State<ExerciceType> {
  bool exerciceTypeSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // track = exerciceTypeSelected = true;
        });
      },
      child: Container(
        width: 115,
        height: 112,
        decoration: BoxDecoration(
          color: exerciceTypeSelected ? null : Color(0xFF2E2F55),
          gradient: exerciceTypeSelected
              ? LinearGradient(
                  colors: [Color(0xFFFFA992), Color(0xFFFD0D92)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          border: Border.all(color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                widget.title,
                style: titleTextStyle(color: Color(0xFFE9E3E4), fontSize: 15),
              ),
              SizedBox(height: 10),
              Image.asset(
                // 'images/icons/${widget.imageName}.png',
                widget.imageName,
                width: 51,
                height: 51,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityButton extends StatelessWidget {
  final String activityName;
  final String imageName;
  final Activity activity;
  // final String routeName;

  const ActivityButton(
      {super.key,
      required this.activityName,
      required this.imageName,
      required this.activity
      // required this.routeName,
      });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.pushNamed(context, routeName);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Hiit(activity: activity)));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2E2F55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        side: BorderSide(
          color: Color(0xFFE8ACFF).withAlpha(51),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            activityName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(width: 10),
          Image.asset(
            imageName,
            width: 57,
            height: 86,
          ),
        ],
      ),
    );
  }
}
