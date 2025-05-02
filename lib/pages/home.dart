import 'package:fitness/components/gradient.dart';
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                    child: GradientComponent.gradientButton('Start', 100, 35)),
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
}
