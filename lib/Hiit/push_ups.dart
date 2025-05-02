import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class PushUps extends StatelessWidget {
  const PushUps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Les Pompes',
          style: titleTextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'images/png/pompes.png',
                ),
                SizedBox(height: 20),
                Text(
                  'Push-ups are a basic exercise to develop strength and power. They work the upper body muscles, but not only that, as it\'s a full-body exercise that engages many other muscles as well!\n'
                  'This bodyweight exercise can be done anywhere, all you need is a floor 😉, and it\'s a basic calisthenics exercise, along with pull-ups, dips, and squats.\n'
                  'Once mastered, classic push-ups can be modified to work muscles at different levels.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Basic Position and Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    ...[
                      'Place your hands on the ground so that they are slightly wider than shoulder-width apart, arms extended, and legs stretched behind you, feet together.\n',
                      'Fingers should be spread out with the index fingers pointing forward and thumbs inward. If your wrists hurt, you can do push-ups on your fists (phalanges), which will lock your wrists.\n',
                      'Your shoulders should be directly above your hands, at the level of your phalanges to keep your forearms perpendicular to the floor, both in the high position and low position.\n',
                      'Your entire body is locked and braced, forming a straight line: head, neck, back, and legs. Contract your abs, glutes, and thighs. You are in a plank position on your hands.\n',
                      'Rotate your arms to point your elbows backward: without moving your hands from the ground, try to rotate your hands outward, as if your thumbs were replacing your index fingers.\n',
                      'Pull your shoulders away from your ears, squeeze your shoulder blades together, and slightly puff out your chest.\n',
                      'Bend your arms to bring your nose, chin, and chest to touch the ground (or very close to the ground) simultaneously.\n',
                      'Do not flare your elbows; they should be relatively close to your body at an angle of less than 45° (do not create a "T-shape" with your arms perpendicular to your body). T-push-ups are a different type of push-up.\n',
                      'Push through your arms, keeping your entire body locked, until you reach the high position with arms fully extended and locked. Be careful not to be too explosive when straightening your arms to avoid injury.\n',
                      'Keep your body braced throughout the entire movement.\n',
                      'Inhale during the lowering phase and exhale during the pushing phase.\n',
                    ]
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: '4 exercises to help you do push-ups'),
                SizedBox(height: 20),
                Text(
                  'If you cannot do push-ups, here is a little program to help you achieve them.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '1) Vertical push-ups or "wall push-ups"',
                    style: titleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/pompes_verticale.png'),
                ),
                Text(
                  'Facing the wall, feet together about 70 cm away from it, place your palms flat against the wall (index pointing up and thumbs pointing inward) so that they are slightly wider than your shoulders, arms extended.\n\n'
                  'Bend your elbows and lightly touch the wall with your nose. Push back to the starting position. Practice maintaining the alignment of your head, back, and legs, and lock your body (abs and glutes contracted).\n\n'
                  'Once you can complete 3 sets of 40 repetitions with 1’30 minutes of rest between sets, move on to the next exercise.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '2) Inclined push-ups',
                    style: titleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/pompes_inclinees.png'),
                ),
                Text(
                  'Facing a bench or chair, place your hands on it, slightly wider than shoulder width, with your arms and legs extended.\n\n'
                  'Bend your elbows and lightly touch the bench with your chest. Push back to the starting position. Keep your body aligned and locked (abs and glutes contracted).\n\n'
                  'The greater the incline, the easier the push-ups will be (you can start with a table height, for example); conversely, the lower the incline (low object: bench, chair), the harder the push-ups will be and closer to full push-ups.\n\n'
                  'You can also use the steps of a staircase and gradually descend one by one to achieve a very low incline (just one step height).\n\n'
                  'Once you can complete 3 sets of 20 repetitions with 1’30 minutes of rest between sets, move on to the next exercise.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '3) Knee push-ups',
                    style: titleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/pompes_sur_genous.png'),
                ),
                Text(
                  'No, these are not "girl push-ups," knee push-ups are regular push-ups but easier because the weight supported by the arms is lighter.\n\n'
                  'Kneel on the floor, feet together, palms flat, slightly wider than shoulder width, arms extended, with your index fingers forward and thumbs inward.\n\n'
                  'Engage your abdominals and glutes and keep your thighs, hips, back, and head aligned. Do not stick your buttocks out when your body is at a 90° angle!\n\n'
                  'Bend your elbows and lightly touch the floor with your chest.\n\n'
                  'Once you can do 3 sets of 20 repetitions with 1\'30" rest between sets, move on to the next exercise.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '4)  Half push-ups',
                    style: titleTextStyle(),
                  ),
                ),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/demi_pompes.png'),
                ),
                Text(
                  'These are the push-ups that many people do thinking they are doing "real" push-ups: they are not done with a full range of motion (arms extended, chest on the floor).\n\n'
                  'Use an object of about 20 cm in height (a ball or a stack of books) and place it under your hips.\n\n'
                  'Get into a push-up position and, while keeping your body straight and engaged, bend your elbows and lightly touch the object with your hips.\n\n'
                  'Push back to the starting position.\n\n'
                  'Once you can do 3 sets of 20 repetitions with 1\'30" rest between sets, congratulations 😉 you can do regular or "normal" push-ups.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientButton(
                  title: 'Go',
                  icon: Icons.arrow_forward,
                  width: 120,
                  onPressed: () {
                    print('Go pressed');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}