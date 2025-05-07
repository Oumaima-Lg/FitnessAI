import 'package:fitness/components/gradient.dart';
import 'package:fitness/data/exercice_data.dart';
import 'package:fitness/models/exercice.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.9, // 90% de la largeur visible par page
  );
  int _currentPage = 0;
  List<Exercice> exercices = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    exercices = ExerciceData.getExercices();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'images/Ellipse.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const Padding(
              padding: EdgeInsets.only(top: 25, left: 15),
              child: Icon(
                Icons.sort,
                color: Colors.white,
                size: 30,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 25),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: ClipOval(
                    child: Image.asset(
                      'images/img.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.only(left: 22, right: 22, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hello, Daniel Matt',
                    style: TextStyle(
                      color: Color.fromARGB(179, 255, 255, 255),
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    )),
                const Text("let's Get Exercise",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 30),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return itemBuilder(context, index);
                    },
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _currentPage == index
                                ? [
                                    Color(0xFFFFA992),
                                    Color(0xFFFD0D92),
                                  ]
                                : [
                                    Color(0xFFFFA992).withAlpha(76),
                                    Color(0xFFFD0D92).withAlpha(76),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 35),
                Text(
                  'Fitness Exercises & Activities',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: exercices
                          .map((exercise) => Row(
                                children: [
                                  exerciceType(
                                    title: exercise.title,
                                    imageName: exercise.imageUrl,
                                  ),
                                  SizedBox(width: 30),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                    child: GradientComponent.gradientButton(
                        text: 'Start',
                        maxWidth: 100,
                        maxHeight: 35,
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ExercicePage()));
                          print("Start");
                        })),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'images/welcome${index + 1}.png',
        ),
      ),
    );
  }

  Widget exerciceType({
    required String title,
    required String imageName,
  }) {
    return GestureDetector(
        child: Container(
      width: 115,
      height: 112,
      decoration: BoxDecoration(
        color: Color(0xFF2E2F55),
        border: Border.all(color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              title,
              style: titleTextStyle(color: Color(0xFFE9E3E4), fontSize: 15),
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
    ));
  }
}
