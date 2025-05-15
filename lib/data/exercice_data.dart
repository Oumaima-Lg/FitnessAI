import 'package:fitness/models/exercice.dart';
import 'package:fitness/models/activity.dart';
import 'package:fitness/services/activity_service.dart';
import 'package:fitness/models/step.dart';

class ExerciceData {
  // Une méthode statique qui renvoie une liste d'exercices avec leurs activités associées
  static Future<List<Exercice>> getExercices() async {
    List<Activity> gymActivities = await ActivityService.fetchGymActivities();

    return [
      Exercice(
        id: '1',
        title: 'HIIT',
        subtitle: 'High-Intensity Interval Training',
        imageUrl: 'images/icons/HIIT.png',
        activities: [
          Activity(
            id: 'a1',
            title: 'Jumping Jack',
            iconUrl: 'images/icons/HIIT/icon1.png',
            imageUrl: 'images/ExerciceImages/jumping_jacks.png',
            description:
                'Jumping jacks are vertical jumps performed on the spot with arms and legs spread apart. This exercise gets its name from the articulated puppet, a wooden toy where the arms raise and the legs spread when you pull the string 😉.',
            techniques: [
              'Jump vertically, spreading your feet and raising your arms to the sides above your head.',
              'Touch your hands together.',
              'Keep your body straight.',
              'Jump again, returning to the starting position, arms by your sides and feet together.',
              'Repeat.'
            ],
            muscleImageUrl: 'images/ExerciceImages/Jumping_jacks_muscles.png',
            muscleDescription:
                'The main muscles worked during jumping jacks are the leg muscles: quadriceps (muscles in the front of the thighs), glutes, and hip flexors.',
            videoDemonstartionUrl: 'images/gif/jumping_jacks.gif',
          ),
          Activity(
            id: 'a2',
            title: 'Wall Sit',
            iconUrl: 'images/icons/HIIT/icon2.png',
            imageUrl: 'images/ExerciceImages/wall_sits.png',
            description:
                'The chair exercise is an isometric exercise that primarily works the thighs.',
            techniques: [
              'Press your back against the wall, feet flat on the ground in front of you;',
              'Lower your body by sliding your back down the wall until you reach an intermediate squat position;',
              'Your thighs should be parallel to the ground and your shins perpendicular to the floor;',
              'Your hips should be aligned with your thighs and knees with your ankles;',
              'Hold the position for the duration of the exercise.',
            ],
            muscleImageUrl: 'images/ExerciceImages/wall_sits_muscles.png',
            muscleDescription:
                'The main muscles worked for the wall sit exercise are the quadriceps, as well as the glutes and hamstrings (muscles at the back of the thigh).',
            videoDemonstartionUrl: 'images/gif/wall_sits.gif',
          ),
          Activity(
            id: 'a3',
            title: 'Push-Ups',
            iconUrl: 'images/icons/HIIT/icon3.png',
            imageUrl: 'images/ExerciceImages/pompes.png',
            description:
                'Push-ups are a basic exercise to develop strength and power. They work the upper body muscles, but not only that, as it\'s a full-body exercise that engages many other muscles as well!\n'
                'This bodyweight exercise can be done anywhere, all you need is a floor 😉, and it\'s a basic calisthenics exercise, along with pull-ups, dips, and squats.\n'
                'Once mastered, classic push-ups can be modified to work muscles at different levels.',
            techniques: [
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
            ],
            muscleImageUrl: 'images/ExerciceImages/pompes_muscles.png',
            muscleDescription:
                'Push-ups mainly work the chest, arms, and shoulders. They also engage the core, back, and legs to keep the body stable, making it a full-body exercise.',
            videoDemonstartionUrl: 'images/gif/jumping_jacks.gif',
          ),
          Activity(
            id: 'a4',
            title: 'Crunches',
            iconUrl: 'images/icons/HIIT/icon4.png',
            imageUrl: 'images/ExerciceImages/crunches.png',
            description:
                'Lie on your back, do not place your hands behind your head, extend your arms, and lift only your upper shoulders while keeping your lower back firmly pressed against the floor.',
            techniques: [
              'Lie flat on your back with your knees bent and feet flat on the floor.',
              'Extend your arms straight out in front of you or cross them on your chest.',
              'Engage your core and lift your upper shoulders off the floor without using momentum.',
              'Keep your lower back pressed firmly against the ground.',
              'Lower back down slowly and repeat.'
            ],
            muscleImageUrl: 'images/ExerciceImages/crunches_muscles.png',
            muscleDescription:
                'Crunches mainly target the abdominal muscles, especially the rectus abdominis (the "six-pack" muscle), along with the obliques to a lesser extent.',
            videoDemonstartionUrl: 'images/gif/jumping_jacks.gif',
          ),
          Activity(
            id: 'a5',
            title: 'Step-Ups onto a Chair',
            iconUrl: 'images/icons/HIIT/icon5.png',
            imageUrl: 'images/ExerciceImages/montee_sur_chaise.png',
            description:
                'Step-ups, whether on a chair, bench, or box, are exercises that particularly target the glutes and thighs.',
            techniques: [
              'Place one foot flat on the support;\n',
              'Shift your weight forward by pushing only with your bent leg;\n',
              'Raise the knee of the opposite leg high towards the ceiling, squeezing your glute (without swinging);\n',
              'Shift your weight back by placing the raised leg directly on the floor;\n',
              'Repeat the movement during the work period;\n',
              'Switch sides during the next round;\n',
            ],
            muscleImageUrl:
                'images/ExerciceImages/montees_sur_chaise_muscle.png',
            muscleDescription:
                'The main muscles worked during step-ups are the glutes and quadriceps.',
            videoDemonstartionUrl: 'images/gif/montee_sur_chaise.gif',
          ),
          Activity(
            id: 'a6',
            title: 'Squats',
            iconUrl: 'images/icons/HIIT/icon6.png',
            imageUrl: 'images/ExerciceImages/squats.png',
            description:
                'A classic in bodybuilding, squats target the entire lower body.',
            techniques: [
              'Stand up straight with your legs fully extended, feet shoulder-width apart, with your toes slightly turned outward;\n',
              'Look straight ahead;\n',
              'Bend your knees by "breaking" the vertical line of your body at the knees and hips;\n',
              'Emphasize the lumbar curve by contracting your abs and pushing your hips back to keep your lower back flat;\n',
              'Think "lower the hips" rather than "lower the torso" while controlling the descent;\n',
              'Keep your knees slightly outward, aligned with your thighs and feet (your knees should be above and in the middle of your feet);\n',
              'Place your weight on your heels (you should be able to wiggle your toes);\n',
              'Lift your arms in front of you as you lower (this will help with balance and overall positioning);\n',
              'At the lowest position, think about puffing out your chest;\n',
              'Lower your hips below knee level (as long as you can keep your back flat); your thighs should be at least parallel to the floor;\n',
              'Stand back up to the starting position, bringing your arms alongside your body (your back, hips, and legs should be aligned and your legs extended);\n',
              'Contract your glutes at the top position to align your hips with your back and legs.',
            ],
            muscleImageUrl: 'images/ExerciceImages/squats_muscles.png',
            muscleDescription:
                'The main muscles worked during squats are the quadriceps (muscles at the front of the thigh) and secondarily the glutes, hamstrings (muscles at the back of the thigh).',
            videoDemonstartionUrl: 'images/gif/squats.gif',
          ),
          Activity(
            id: 'a7',
            title: 'Tricep Dips Using a Chair',
            iconUrl: 'images/icons/HIIT/icon7.png',
            imageUrl: 'images/ExerciceImages/dips_sur_chaise.png',
            description:
                'Chair dips or bench dips are an exercise that targets the triceps.',
            techniques: [
              'Bend your arms while controlling the descent;\n',
              'Lower yourself until your triceps are parallel to the ground;\n',
              'Push up by fully extending your arms;\n',
              'Keep your back straight and puff your chest out during the movement.\n',
              'Repeat',
            ],
            muscleImageUrl: 'images/ExerciceImages/dips_sur_chaise_muscles.png',
            muscleDescription:
                'The main muscles worked for chair dips are the triceps.',
            videoDemonstartionUrl: 'images/gif/dips_sur_chaise.gif',
          ),
          Activity(
            id: 'a8',
            title: 'Plank',
            iconUrl: 'images/icons/HIIT/icon8.png',
            imageUrl: 'images/ExerciceImages/planches.png',
            description:
                'The plank is a classic core exercise performed on the forearms.',
            techniques: [
              'Lie face down, supporting your weight on your forearms and toes;\n',
              'You can place your hands flat on the floor or interlace them as you prefer;\n',
              'Position your elbows under your shoulders;\n',
              'Keep your body straight from head to toe (aligning ankles/knees/hips and shoulders);\n',
              'Contract your abs to maintain a straight body and prevent arching (don\'t let your hips sag towards the ground);\n',
              'Contract your glutes and thighs to maintain a straight body and prevent lifting your hips (don\'t let your hips rise);\n',
              'Look at the floor to avoid creating tension in your neck and to keep alignment with your back.',
            ],
            muscleImageUrl: 'images/ExerciceImages/planche_muscles.png',
            muscleDescription:
                'The primary muscle worked in the plank is the rectus abdominis (the abdominal muscles). The glutes and obliques are worked secondarily.',
            videoDemonstartionUrl: 'images/gif/planche.gif',
          ),
          Activity(
            id: 'a9',
            title: 'High Knees',
            iconUrl: 'images/icons/HIIT/icon9.png',
            imageUrl: 'images/ExerciceImages/leves_genoux.png',
            description:
                'The knee raises or knee lifts exercise involves running in place; it is a very effective cardio exercise that will also work the legs and abs.\n'
                'If you don\'t have space to run or the weather doesn\'t allow you to train outside, it can be a good substitute for sprints.',
            techniques: [
              'Start running in place by lifting your knees high;\n',
              'Run on the balls of your feet;\n',
              'Swing the opposite arm to the raised knee to maintain balance;\n',
              'Look straight ahead;\n',
              'Keep your back straight and engage your core.',
            ],
            muscleImageUrl: 'images/ExerciceImages/leve_genoux_muscles.png',
            muscleDescription:
                'The main muscles worked during knee lifts / running in place are the quadriceps, calves, and abdominals.',
            videoDemonstartionUrl: 'images/gif/levee_genoux.gif',
          ),
          Activity(
            id: 'a10',
            title: 'Forward Lunges',
            iconUrl: 'images/icons/HIIT/icon10.png',
            imageUrl: 'images/ExerciceImages/fentes.png',
            description:
                'Lunges (forward or backward) are effective exercises that target the thighs and glutes.',
            techniques: [
              'Take a big step forward while keeping your back straight (your other foot stays behind);\n',
              'Lower your body until your back knee nearly touches the floor (control the descent to avoid hitting your knee);\n',
              'The shin of your front leg should be perpendicular to the floor, with your knee above your foot (don’t let the knee go past your toes);\n',
              'Return to the starting position and alternate the movement on the other side.',
            ],
            muscleImageUrl: 'images/ExerciceImages/fents_muscle.png',
            muscleDescription:
                'The main muscles worked during lunges are the quadriceps (the muscles at the front of the thigh) and the glutes.',
            videoDemonstartionUrl: 'images/gif/fents.gif',
          ),
          Activity(
            id: 'a11',
            title: 'T-Push-Ups',
            iconUrl: 'images/icons/HIIT/icon11.png',
            imageUrl: 'images/ExerciceImages/pompes_T.png',
            description:
                'T-push-ups are variations of push-ups that combine a full push-up with a side plank. This exercise strengthens the abdominals in addition to the triceps, shoulders, and chest.',
            techniques: [
              'Pivot your body to one side and raise your arm towards the ceiling to form a "T" (arms extended perpendicular to your engaged body);\n',
              'You are in a side plank position with both arms extended and aligned;\n',
              'Return to the starting position, arms extended;\n',
              'Perform a full push-up.\n',
              'Repeat',
            ],
            muscleImageUrl: 'images/ExerciceImages/pompes_T_muscles.png',
            muscleDescription:
                'The main muscles worked in T-push-ups are the pectorals, deltoids, triceps, and abdominals (obliques and rectus abdominis).',
            videoDemonstartionUrl: 'images/gif/pompes_T.gif',
          ),
          Activity(
            id: 'a12',
            title: 'Side Plank',
            iconUrl: 'images/icons/HIIT/icon12.png',
            imageUrl: 'images/ExerciceImages/planche_laterale.png',
            description:
                'The side plank or side plank hold is an isometric exercise targeting the oblique abdominals. It is the plank exercise performed on the side.',
            techniques: [
              'Support your weight on your forearm (elbow under the shoulder) and the outer side of your foot (with legs joined, stacked, and extended), the opposite hand placed on your hip or along your thigh;\n',
              'Engage your abdominals, glutes, and thighs to maintain your body alignment in a straight line (ankles, knees, hips, spine, and head);\n',
              'Hold the position for the work time and switch sides.',
            ],
            muscleImageUrl: 'images/ExerciceImages/planche_laterale_muscle.png',
            muscleDescription:
                'The main muscles worked in the side plank are the obliques.',
            videoDemonstartionUrl: 'images/gif/planche_lateral.gif',
          ),
        ],
      ),
      Exercice(
        id: '2',
        title: 'Cardio',
        subtitle:
            'Boost your heart health and burn calories with high-energy movement.',
        imageUrl: 'images/icons/Cardio.png',
        activities: [
          Activity(
            id: 'a1',
            title: 'Running',
            iconUrl: 'images/icons/Cardio/icon1.png',
            imageUrl: 'images/ExerciceImages/running2.png',
            description:
                'Running is a fundamental cardiovascular exercise involving continuous, rhythmic movement where individuals propel themselves forward on foot at a pace faster than walking. It enhances cardiovascular health, strengthens muscles, improves endurance, and supports mental well-being. \n Widely practiced for fitness, sport, and recreation, running can range from light jogging to competitive racing. It requires minimal equipment, is accessible to all fitness levels, and can be done almost anywhere—from treadmills and tracks to city streets and nature trails.\n Whether for stress relief, weight loss, or athletic training, running remains a timeless and effective full-body workout.',
            videoDemonstartionUrl: 'images/gif/running.gif',
            steps: [
              StepItem(
                id: 'r1',
                stepTitle: 'Warm Up Properly',
                stepDescription:
                    'Start with dynamic stretches or light jogging to gradually increase your heart rate and loosen your muscles, preparing your body for the run.',
              ),
              StepItem(
                id: 'r2',
                stepTitle: 'Maintain Good Posture',
                stepDescription:
                    'Keep your back straight, head up, and shoulders relaxed. Proper posture improves breathing and running efficiency.',
              ),
              StepItem(
                id: 'r3',
                stepTitle: 'Control Your Breathing',
                stepDescription:
                    'Breathe deeply and rhythmically, ideally through both your nose and mouth. This helps maintain endurance and reduces fatigue.',
              ),
              StepItem(
                id: 'r4',
                stepTitle: 'Find Your Pace',
                stepDescription:
                    'Start at a comfortable pace you can maintain. Don’t rush early—conserve energy for the entire run or later sprints.',
              ),
              StepItem(
                id: 'r5',
                stepTitle: 'Cool Down & Stretch',
                stepDescription:
                    'Slow down gradually to a walk, then stretch your muscles to aid recovery and prevent stiffness.',
              ),
            ],
          ),
          Activity(
            id: 'a2',
            title: 'Jump Rope',
            iconUrl: 'images/icons/Cardio/icon2.png',
            imageUrl: 'images/ExerciceImages/jumpRope2.png',
            description:
                'Jump Rope (Skipping) is a dynamic cardiovascular exercise where individuals swing a rope around their body and jump over it rhythmically. It improves coordination, agility, endurance, and burns calories efficiently.\n Popular in fitness routines, sports training, and playgrounds, it can be adapted for speed, tricks (e.g., double-unders, crossovers), or group challenges. Affordable and portable, it’s a versatile workout for all fitness levels.',
            videoDemonstartionUrl: 'images/gif/JumpRope.gif',
            steps: [
              StepItem(
                id: 's1',
                stepTitle: 'Spread Your Arms',
                stepDescription:
                    'To make the gestures feel more relaxed, stretch your arms as you start this movement. No bending of hands.',
              ),
              StepItem(
                id: 's2',
                stepTitle: 'Rest at The Toe',
                stepDescription:
                    'The basis of this movement is jumping. Now, what needs to be considered is that you have to use the tips of your feet',
              ),
              StepItem(
                id: 's3',
                stepTitle: 'Adjust Foot Movement',
                stepDescription:
                    'Jumping Jack is not just an ordinary jump. But, you also have to pay close attention to leg movements.',
              ),
              StepItem(
                id: 's4',
                stepTitle: 'Clapping Both Hands',
                stepDescription:
                    'This cannot be taken lightly. You see, without realizing it, the clapping of your hands helps you to keep your rhythm while doing the Jumping Jack',
              ),
            ],
          ),
        ],
      ),
      Exercice(
        id: '3',
        title: 'Gym',
        subtitle:
            'Train safely and effectively with machines designed to target specific muscle groups.',
        imageUrl: 'images/icons/Gym.png',
        activities: gymActivities,
      ),
      Exercice(
        id: '4',
        title: 'Recovery',
        subtitle:
            'Relax, restore, and strengthen the connection between your body and mind.',
        imageUrl: 'images/icons/recovery.png',
        activities: [
          Activity(
            id: 'a1',
            title: 'Breathing Exercises',
            iconUrl: 'images/icons/HIIT/icon1.png',
            videoDemonstartionUrl: 'images/gif/breathing.gif',
            steps: [
              StepItem(
                id: 's1',
                stepTitle: 'Step 1',
                stepImage: 'images/icons/Recovery/etape1.png',
                stepDescription:
                    'Start by getting into a comfortable position (for example, sitting on a chair with armrests and feet flat on the floor or on a stool; or lying on the floor or bed, with your lower legs resting on cushions and a rolled towel under your neck).',
              ),
              StepItem(
                id: 's2',
                stepTitle: 'Step 2',
                stepImage: 'images/icons/Recovery/etape1.png',
                stepDescription:
                    'Make sure you won’t be interrupted during the exercise (you can turn off your phone). Let those around you know that you DO NOT WANT TO BE DISTURBED.',
              ),
              StepItem(
                id: 's3',
                stepTitle: 'Step 3',
                stepImage: 'images/icons/Recovery/etape1.png',
                stepDescription:
                    'Remove your shoes and loosen any tight clothing. Make sure you’re not feeling cold.',
              ),
              StepItem(
                id: 's4',
                stepTitle: 'Step 4',
                stepImage: 'images/icons/Recovery/etape2.png',
                stepDescription:
                    'Close your eyes. Place your hands on your belly.',
              ),
              StepItem(
                id: 's5',
                stepTitle: 'Step 5',
                stepImage: 'images/icons/Recovery/etape2.png',
                stepDescription:
                    'Tell yourself: “I’m now going to relax by learning how to breathe down into my belly.”',
              ),
              StepItem(
                id: 's6',
                stepTitle: 'Step 6',
                stepImage: 'images/icons/Recovery/etape3.png',
                stepDescription:
                    'First, take a deep breath and then exhale forcefully, making a sigh of relief. (This is called a cleansing breath. It signals your body to begin breathing more deeply.) Repeat two or three times.',
              ),
              StepItem(
                id: 's7',
                stepTitle: 'Step 7',
                stepImage: 'images/icons/Recovery/etape3.png',
                stepDescription:
                    'Then, focus on breathing slowly at a pace that feels comfortable for you.',
              ),
              StepItem(
                id: 's8',
                stepTitle: 'Step 8',
                stepImage: 'images/icons/Recovery/etape3.png',
                stepDescription: 'Inhale through your nose.',
              ),
              StepItem(
                id: 's9',
                stepTitle: 'Step 9',
                stepImage: 'images/icons/Recovery/etape3.png',
                stepDescription:
                    'Exhale through your mouth, with your lips slightly pursed.',
              ),
              StepItem(
                id: 's10',
                stepTitle: 'Step 10',
                stepImage: 'images/icons/Recovery/etape4.png',
                stepDescription:
                    'To help you inhale slowly and deeply, imagine the air moving gently down into your belly. Feel your belly expand.',
              ),
              StepItem(
                id: 's11',
                stepTitle: 'Step 11',
                stepImage: 'images/icons/Recovery/etape5.png',
                stepDescription:
                    'To help you exhale slowly, purse your lips and imagine you’re blowing on a candle flame—just enough to make it flicker, but not go out.',
              ),
              StepItem(
                id: 's12',
                stepTitle: 'Step 12',
                stepImage: 'images/icons/Recovery/etape5.png',
                stepDescription:
                    'Continue the exercise at your own pace. Think about breathing in slowly through your nose, filling your belly with air, and then exhaling so that your abdomen slowly deflates as the air flows out through your mouth.',
              ),
              StepItem(
                id: 's13',
                stepTitle: 'Step 13',
                stepImage: 'images/icons/Recovery/etape5.png',
                stepDescription:
                    'With each exhalation, focus on relaxing a different part of your body and feeling a sense of warmth and support. Start with your toes and gradually move up toward your head.',
              ),
              StepItem(
                id: 's14',
                stepTitle: 'Step 14',
                stepImage: 'images/icons/Recovery/etape5.png',
                stepDescription:
                    'Continue this exercise for 10 to 15 minutes to reach a deep state of relaxation, then finish with one last cleansing breath.',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
