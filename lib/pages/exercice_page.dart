import 'package:fitness/data/exercice_data.dart';
import 'package:fitness/entrainements/cardio.dart';
import 'package:fitness/entrainements/recovery.dart';
import 'package:fitness/entrainements/hiit.dart';
import 'package:fitness/models/activity.dart';
import 'package:fitness/models/exercice.dart';
import 'package:fitness/pages/go.dart';
import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../components/textStyle/textstyle.dart';

class ExercicePage extends StatefulWidget {
  const ExercicePage({
    super.key,
  });

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  List<Exercice> exercices = [];
  int track = 0;

  @override
  void initState() {
    super.initState();
    exercices = ExerciceData.getExercices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                              exerciceType(
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
                        text: exercices[track].title,
                        alignment: Alignment.center,
                        fontSize: 20,
                      ),
                      Etoile(),
                    ],
                  ),
                  SizedBox(height: 10),
                  GradientTitleText(
                    text: exercices[track].subtitle,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 20),
                  Image(
                    image: AssetImage(exercices[track].imageUrl),
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
                    itemCount: exercices[track].activities.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      var activities = exercices[track].activities;
                      final activity = activities[index];
                      return ActivityButton(
                        activityName: activity.title,
                        imageName: activity.iconUrl,
                        activity: activity,
                      );
                    },
                  ),
                ],
              ),
              // SizedBox(height: 50),
              // getSelectedActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget exerciceType(
      {required String title,
      required String imageName,
      required int exerciceIndex}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          track = exerciceIndex;
        });
      },
      child: track == exerciceIndex
          ? Container(
              width: 115,
              height: 112,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFA992), Color(0xFFFD0D92)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                    color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: titleTextStyle(
                          color: Color(0xFFE9E3E4), fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Image.asset(
                      imageName,
                      width: 51,
                      height: 51,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: 115,
              height: 112,
              decoration: BoxDecoration(
                color: Color(0xFF2E2F55),
                border: Border.all(
                    color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: titleTextStyle(
                          color: Color(0xFFE9E3E4), fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Image.asset(
                      imageName,
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

class ActivityButton extends StatelessWidget {
  final String activityName;
  final String imageName;
  final Activity activity;

  const ActivityButton(
      {super.key,
      required this.activityName,
      required this.imageName,
      required this.activity});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (activity.techniques != null && activity.techniques!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Hiit(activity: activity)),
          );
        } else if (activity.steps != null && activity.steps!.isNotEmpty && activity.steps!.every((s) => s.stepImage != null && s.stepImage!.isNotEmpty)) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Recovery(activity: activity)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cardio(activity: activity,)),
          );
        } 
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
