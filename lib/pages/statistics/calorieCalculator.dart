import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CalorieCalculator {
  static const Map<String, double> activityMETs = {
    'Jumping Jack': 8.0,
    'Wall Sit': 4.0,
    'Push-Ups': 8.0,
    'Crunches': 4.0,
    'Step-Ups onto Chair': 6.0,
    'Squats': 5.0,
    'Tricep Dips Using a Chair': 5.0,
    'Plank': 3.3,
    'High Knees': 8.0,
    'Forward Lunges': 6.0,
    'T-Push-Ups': 8.0,
    'Side Plank': 3.3,
  };

  static Future<double> calculateCaloriesBurned({
    required String activityName,
    required int durationSeconds,
    required String userId,
  }) async {
    try {
      // 1. Récupérer le poids de l'utilisateur
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final weight = userDoc.data()?['weight'] as double?;
      if (weight == null) throw Exception('Poids utilisateur non trouvé');

      // 2. Trouver le MET correspondant
      final met = activityMETs[activityName] ?? 5.0; // Valeur par défaut

      // 3. Calcul selon la formule
      final durationMinutes = durationSeconds / 60;
      final calories = (met * 3.5 * weight / 200) * durationMinutes;

      return calories;
    } catch (e) {
      print('Erreur calcul calories: $e');
      return 0.0;
    }
  }

  // Alternative: version avec poids directement en paramètre
  static double calculateWithWeight({
    required String activityName,
    required int durationSeconds,
    required double weightKg,
  }) {
    final met = activityMETs[activityName] ?? 5.0;
    return (met * 3.5 * weightKg / 200) * (durationSeconds / 60);
  }

  static Future<double> calculateTotalCaloriesBurned(String userId) async {
    try {
      final today = DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(today);
      
      // 1. Récupérer le poids de l'utilisateur avec plus de debug
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      print('Checking user data...');
      print('User document exists: ${userDoc.exists}');
      if (userDoc.exists) {
        print('User data: ${userDoc.data()}');
      }

      final weight = userDoc.data()?['weight'];
      print('Retrieved weight: $weight');

      // Use default weight if not found
      double userWeight;
      if (weight == null) {
        print('Weight not found, using default weight of 70kg');
        userWeight = 70.0; // Default weight in kg
      } else {
        userWeight = weight is int ? weight.toDouble() : weight as double;
      }

      // 2. Récupérer tous les workouts du jour
      final workoutsDoc = await FirebaseFirestore.instance
          .collection('user_workouts')
          .doc(userId)
          .collection('daily_sessions')
          .doc(dateKey)
          .get();

      if (!workoutsDoc.exists) return 0.0;

      final workouts = workoutsDoc.data()?['workouts'] as List<dynamic>?;
      if (workouts == null) return 0.0;

      // 3. Calculer les calories pour chaque workout
      double totalCalories = 0.0;
      for (var workout in workouts) {
        final activityName = workout['activity_name'] as String;
        final duration = workout['duration'] as int;
        
        final calories = calculateWithWeight(
          activityName: activityName,
          durationSeconds: duration,
          weightKg: userWeight,
        );
        
        totalCalories += calories;
        print('Calories for $activityName: $calories (duration: ${duration}s)');
      }

      print('Total calories burned today: $totalCalories');

      // Sauvegarder le total des calories dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyStats')
          .doc(dateKey)
          .set({
            'calories': totalCalories,
            'last_update': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      print('Calories sauvegardées dans Firestore: $totalCalories');
      return totalCalories;
    } catch (e) {
      print('Detailed error in calorie calculation:');
      print(e);
      return 0.0;
    }
  }
}