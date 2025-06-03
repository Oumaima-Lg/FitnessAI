// lib/utils/met_values.dart

class ActivityMETs {
  static const Map<String, double> values = {
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
    // Ajoutez d'autres activités au besoin
  };

  static double getMET(String activityName) {
    return values[activityName] ?? 5.0; // Valeur par défaut si non trouvé
  }
}