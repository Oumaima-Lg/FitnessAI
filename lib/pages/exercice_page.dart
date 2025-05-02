import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class ExercicePage extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {'name': 'Jumping Jack', 'image': 'Jumping Jack/1.png','route': '/jumping_jack'},
    {'name': 'Wall Sit', 'image': 'Wall Sit/img2.png','route': '/wall_sit'},
    {'name': 'Push-Ups', 'image': 'img3.png','route': '/push_ups'},
    {'name': 'Crunches', 'image': 'img4.png','route': '/crunches'},
    {'name': 'Step-Ups onto a Chair', 'image': 'img5.png','route': '/steps_ups'},
    {'name': 'Squats', 'image': 'img6.png','route': '/squats'},
    {'name': 'Tricep Dips Using a Chair', 'image': 'img7.png','route': '/tricep_dips_using_a_chair'},
    {'name': 'Plank', 'image': 'img8.png','route': '/plank'},
    {'name': 'High Knees', 'image': 'img9.png','route': '/high_knees'},
    {'name': 'Forward Lunges', 'image': 'img10.png','route': '/forward_lunges'},
    {'name': 'T-Push-Ups', 'image': 'img11.png','route': '/t_push_ups'},
    {'name': 'Side Plank', 'image': 'img12.png','route': '/side_plank'},
  ];

  final List<Map<String, String>> exerciseTypes = [
    {'title': 'HIIT', 'image': 'HIIT'},
    {'title': 'Cardio', 'image': 'Cardio'},
    {'title': 'Gym', 'image': 'Gym'},
    {'title': 'Recovery', 'image': 'recovery'},
  ];

  ExercicePage({super.key,});

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
                  children: exerciseTypes
                    .map((exercise) => Row(
                          children: [
                            ExerciceType(
                              title: exercise['title']!,
                              imageName: exercise['image']!,
                            ),
                            SizedBox(width: 20),
                          ],
                        ))
                    .toList(),
                ),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Etoile(),
                      SizedBox(width: 10),
                      Text(
                        'HIIT',
                        style: titleTextStyle(color: Color(0xFFFD0D92),),
                      ),
                      SizedBox(width: 10),
                      Etoile(),
                    ],
                  ),
                  SizedBox(height: 20),
                  GradientTitleText(text: 'High-Intensity Interval Training', alignment:  Alignment.center,),
                  SizedBox(height: 20),
                  Image(
                    image: AssetImage('images/icons/HIIT.png'),
                    width: 110,
                    height: 110,
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ 
                  Text(
                    'Activities',
                    style: titleTextStyle(),
                  ),
                  SizedBox(height: 20),
                  ListView.separated(
                    itemCount: activities.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ActivityButton(
                        actvityName: activity['name']!,
                        imageName: activity['image']!,
                        routeName: activity['route'] ?? '/jumping_jack',
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
  
  const ExerciceType({
    super.key,
    required this.title,
    required this.imageName,
  });

  @override
  State<ExerciceType> createState() => _ExerciceTypeState();
}

class _ExerciceTypeState extends State<ExerciceType> {
  bool exerciceTypeSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          exerciceTypeSelected = true;
        });
      },
      child: Container(
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: exerciceTypeSelected ? null : Color(0xFF2E2F55),
          gradient: exerciceTypeSelected
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
                widget.title,
                style: titleTextStyle(color: Color(0xFFE9E3E4)),
              ),
              SizedBox(height: 10),
              Image.asset(
                'images/icons/${widget.imageName}.png',
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
  final String actvityName;
  final String imageName;
  final String routeName; 

  const ActivityButton({
    super.key,
    required this.actvityName,
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
            actvityName,
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
