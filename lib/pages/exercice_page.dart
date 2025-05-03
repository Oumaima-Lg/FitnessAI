import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class ExercicePage extends StatefulWidget {
  const ExercicePage({super.key,});
  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  String selectedExercise = 'HIIT';
  
  final List<Map<String, String>> exerciseTypes = [
    {'title': 'HIIT', 'image': 'HIIT'},
    {'title': 'Cardio', 'image': 'Cardio'},
    {'title': 'Gym', 'image': 'Gym'},
    {'title': 'Recovery', 'image': 'Recovery'}, 
  ];

  Widget getSelectedActivity() {
    switch (selectedExercise) {
      case 'HIIT':
        return HiitExercice();
      case 'Cardio':
        return CardioExercice();
      case 'Gym':
        return GymExercice();
      case 'Recovery':
        return RecoveryExercice();
      default:
        return SizedBox();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Fitness Exercises & Activities',
          style: titleTextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: exerciseTypes.map((exercise) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedExercise = exercise['title']!;
                            });
                          },
                          child: ExerciceType(
                            title: exercise['title']!,
                            imageName: exercise['image']!,
                            isSelected: selectedExercise == exercise['title'],
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 50),
              getSelectedActivity(),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciceType extends StatelessWidget {
  final String title;
  final String imageName;
  final bool isSelected;

  const ExerciceType({
    super.key,
    required this.title,
    required this.imageName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: isSelected ? null : Color(0xFF2E2F55),
        gradient: isSelected
            ? LinearGradient(
                colors: [Color(0xFFFFA992), Color(0xFFFD0D92)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        border: Border.all(color: Color(0xFF4E457B), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              title,
              style: titleTextStyle(color: Color(0xFFE9E3E4)),
            ),
            SizedBox(height: 10),
            Image.asset(
              'images/icons/$imageName.png',
              width: 51,
              height: 51,
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciceActivities extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Map<String, String>> activities;

  const ExerciceActivities({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Etoile(),
            SizedBox(width: 10),
            Text(
              title,
              style: titleTextStyle(color: Color(0xFFFD0D92)),
            ),
            SizedBox(width: 10),
            Etoile(),
          ],
        ),
        SizedBox(height: 20),
        GradientTitleText(
          text: subtitle,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Image.asset(
          imagePath,
          width: 110,
          height: 110,
        ),
        SizedBox(height: 20),
        Text(
          'Activities',
          style: titleTextStyle(),
        ),
        SizedBox(height: 20),
        ListView.separated(
          itemCount: activities.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ActivityButton(
              activityName: activity['name']!,
              imageName: activity['image']!,
              routeName: activity['route']!,
            );
          },
        ),
      ],
    );
  }
}

class HiitExercice extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {'name': 'Jumping Jack', 'image': 'Jumping Jack/1.png', 'route': '/jumping_jack'},
    {'name': 'Wall Sit', 'image': 'Wall Sit/img2.png', 'route': '/wall_sit'},
    {'name': 'Push-Ups', 'image': 'img3.png', 'route': '/push_ups'},
    {'name': 'Crunches', 'image': 'img4.png', 'route': '/crunches'},
    {'name': 'Step-Ups onto a Chair', 'image': 'img5.png', 'route': '/steps_ups'},
    {'name': 'Squats', 'image': 'img6.png', 'route': '/squats'},
    {'name': 'Tricep Dips Using a Chair', 'image': 'img7.png', 'route': '/tricep_dips_using_a_chair'},
    {'name': 'Plank', 'image': 'img8.png', 'route': '/plank'},
    {'name': 'High Knees', 'image': 'img9.png', 'route': '/high_knees'},
    {'name': 'Forward Lunges', 'image': 'img10.png', 'route': '/forward_lunges'},
    {'name': 'T-Push-Ups', 'image': 'img11.png', 'route': '/t_push_ups'},
    {'name': 'Side Plank', 'image': 'img12.png', 'route': '/side_plank'},
  ];

  HiitExercice({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciceActivities(
      title: 'HIIT',
      subtitle: 'High-Intensity Interval Training',
      imagePath: 'images/icons/HIIT.png',
      activities: activities,
    );
  }
}

class CardioExercice extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {'name': 'Cardiovascular Training', 'image': 'img3.png', 'route': '/jumping_jack'},
    {'name': 'Jump Rope', 'image': 'img3.png', 'route': '/jumping_jack'},
  ];

  CardioExercice({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciceActivities(
      title: 'Cardio',
      subtitle: 'Boost your heart health and burn calories with high-energy movement.',
      imagePath: 'images/icons/Cardio.png',
      activities: activities,
    );
  }
}

class GymExercice extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {'name': 'Strength Training Machines', 'image': 'img3.png', 'route': '/jumping_jack'},
  ];

  GymExercice({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciceActivities(
      title: 'Gym Machines',
      subtitle: 'Train safely and effectively with machines designed to target specific muscle groups.',
      imagePath: 'images/icons/Gym.png',
      activities: activities,
    );
  }
}

class RecoveryExercice extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {'name': 'Breathing Exercises', 'image': 'img3.png', 'route': '/jumping_jack'},
  ];

  RecoveryExercice({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciceActivities(
      title: 'Mind-Body & Recovery',
      subtitle: 'Relax, restore, and strengthen the connection between your body and mind.',
      imagePath: 'images/icons/Recovery.png',
      activities: activities,
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
  final String routeName; 

  const ActivityButton({
    super.key,
    required this.activityName,
    required this.imageName,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2E2F55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        side: BorderSide(
          color: Color(0xFF4E457B),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            activityName,
            style: TextStyle(
              color: Color(0xFFE9E3E4),
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
          Image.asset(
            'images/icons/HIIT/$imageName',
            width: 57,
            height: 86,
          ),
        ],
      ),
    );
  }
}
