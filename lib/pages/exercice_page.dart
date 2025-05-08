import 'package:fitness/data/exercice_data.dart';
import 'package:fitness/entrainements/cardio.dart';
import 'package:fitness/entrainements/gym.dart';
import 'package:fitness/entrainements/hiit.dart';
import 'package:fitness/entrainements/recovery.dart';
import 'package:fitness/models/activity.dart';
import 'package:fitness/models/exercice.dart';
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
  final TextEditingController _controller = TextEditingController();
  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    List<Exercice> data = await ExerciceData.getExercices();
    setState(() {
      exercices = data;
    });
    // exercices = ExerciceData.getExercices();

    _controller.addListener(() {
      setState(() {
        _isWriting = _controller.text.isNotEmpty;
      });
    });
  }

  List<Activity> get filteredActivities {
    final query = _controller.text.toLowerCase();

    if (query.isEmpty) {
      return exercices[track].activities;
    }
    return exercices
        .expand((ex) => ex.activities)
        .where((activity) => activity.title
            .toLowerCase()
            .split(' ')
            .any((word) => word.startsWith(query)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (exercices.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              searchBar(),
              SizedBox(height: 10),
              if (!_isWriting)
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
              if (!_isWriting)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  filteredActivities.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'There is no activity',
                              style: normalTextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredActivities.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final activity = filteredActivities[index];
                            return activitybutton(
                              activityName: activity.title,
                              imageName: activity.iconUrl,
                              activity: activity,
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

  GestureDetector searchBar() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0x804E457B),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.search,
              color: Color(0xFF8E8E8E),
              size: 24,
            ),
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: _isWriting ? Colors.white : Color(0xFF8E8E8E),
                ),
                decoration: InputDecoration(
                  hintText: 'Search your favourite activity',
                  hintStyle: normalTextStyle(color: Color(0xFF8E8E8E)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(
              Icons.tune,
              color: Color(0xFF8E8E8E),
              size: 24,
            ),
          ],
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
                      'images/icons/Gym.png',
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

  Widget activitybutton(
      {required String activityName,
      required String imageName,
      required Activity activity}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2E2F55),
                      Color(0xFF23253C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Builder(
                  builder: (context) {
                    switch (track) {
                      case 0:
                        return Hiit(activity: activity);
                      case 1:
                        return Cardio(activity: activity);
                      case 2:
                        return Gym(activity: activity);
                      case 3:
                        return Recovery(activity: activity);
                      default:
                        return Hiit(activity: activity);
                    }
                  },
                ),
              );
            },
          ),
        );
        // if (activity.techniques != null && activity.techniques!.isNotEmpty) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Hiit(activity: activity)),
        //   );
        // } else if (activity.steps != null && activity.steps!.isNotEmpty && activity.steps!.every((s) => s.stepImage != null && s.stepImage!.isNotEmpty)) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Recovery(activity: activity)),
        //   );
        // } else {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => Cardio(activity: activity,)),
        //   );
        // }
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
          Flexible(
            flex: 3,
            child: Text(
              activityName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: track == 2
                ? Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  )
                : Image(
                    image: AssetImage(imageName),
                    width: 57,
                    height: 86,
                    fit: BoxFit.contain,
                  ),
          ),
        ],
      ),
    );
  }
}
