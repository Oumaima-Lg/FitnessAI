import 'package:fitness/models/activity.dart';
import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../components/textStyle/textstyle.dart';

class Gym extends StatelessWidget {
  final Activity activity;

  const Gym({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          activity.title,
          style: titleTextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscle Group'),
                // Stack(
                //   children: [
                //     Positioned(
                //       // left: 0,
                //       // top: 5,
                //       // right: 0,
                //       // bottom: 0,
                //       child: Center(
                //         child: Image.asset(
                //           'images/Ellipse Gym.png',
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       left: 140,
                //       top: 190,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         spacing: 20,
                //         children: [
                //           Etoile(
                //             size: 30,
                //           ),
                //           Text(
                //             (activity.target!).toUpperCase(),
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 30,
                //               fontFamily: 'Poppins',
                //               fontWeight: FontWeight.bold,
                //             ),
                //             textAlign: TextAlign.center,
                //           ),
                //           Etoile(
                //             size: 30,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  // Ajoutez un conteneur avec une taille fixe
                  width: 390, // Ajustez selon vos besoins
                  height: 300, // Ajustez selon vos besoins
                  child: Stack(
                    alignment:
                        Alignment.center, // Centre tous les enfants du Stack
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'images/Ellipse Gym.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Etoile(size: 30),
                          const SizedBox(width: 20),
                          Text(
                            (activity.target!).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Etoile(size: 30),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(
                      color: Color(0xFFE8ACFF).withAlpha(51),
                      width: 2,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16),
                            child: GradientTitleText(
                              text: 'Body Part',
                              textAlign: TextAlign.center,
                              alignment: Alignment.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16),
                            child: Text(
                              activity.bodyPart!,
                              style: normalTextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16),
                            child: GradientTitleText(
                              text: 'Equipment',
                              textAlign: TextAlign.center,
                              alignment: Alignment.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16),
                            child: Text(
                              activity.equipment!,
                              style: normalTextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                GradientTitleText(text: 'Secondary Muscles'),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: activity.secondaryMuscles != null &&
                          activity.secondaryMuscles!.isNotEmpty
                      ? Row(
                          children: activity.secondaryMuscles!
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: 30), // Marge entre les éléments
                                    child: secondaryMuscles(
                                      title:
                                          item, // Utilisation correcte de `item`
                                    ),
                                  ))
                              .toList(),
                        )
                      : Center(
                          child: Text(
                              'No secondary muscles found')), // Message si la liste est vide ou nulle
                ),
                SizedBox(height: 35),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stand with your feet hip-width apart, hands by your sides:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...activity.techniques!.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 25),
                GradientTitleText(text: 'Demonstration'),
                SizedBox(height: 20),
                Stack(
                  children: [
                    Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            color: Color(0xFFF4E3DF),
                          ),
                        )),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: Image(
                        image: NetworkImage(activity.videoDemonstartionUrl!),
                        fit: BoxFit.cover,
                        // width: MediaQuery.of(context).size.width / 1.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                goButton(context, activity: activity),
                // GradientButton(
                //   title: 'Go',
                //   icon: Icons.arrow_forward,
                //   maxWidth: 120,
                //   maxHeight: 42,
                //   onPressed: () {
                //     print('Go pressed');
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget secondaryMuscles({
    required String title,
  }) {
    return GestureDetector(
        child: Container(
      width: 131,
      height: 61,
      decoration: BoxDecoration(
        color: Color(0xFF2E2F55),
        border: Border.all(color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            "${title[0].toUpperCase()}${title.substring(1)}",
            style: titleTextStyle(
              color: Color(0xFFE9E3E4),
              fontSize: 15,
            ),
          ),
        ),
      ),
    ));
  }
}
