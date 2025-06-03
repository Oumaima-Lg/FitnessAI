import 'package:fitness/models/activity.dart';
import 'package:fitness/models/exercice.dart';
import 'package:fitness/data/exercice_data.dart';

class ExerciceService {
  static Future<String?> getActivityIconUrl(
      String exerciceTitle, String activityTitle) async {
    try {
      // Récupérer tous les exercices
      List<Exercice> exercices = await ExerciceData.getExercices();

      // Chercher l'exercice par son titre
      Exercice? targetExercice = exercices.firstWhere(
        (exercice) =>
            exercice.title.toLowerCase() == exerciceTitle.toLowerCase(),
        orElse: () => throw Exception('Exercice not found'),
      );

      // Chercher l'activité par son titre dans l'exercice trouvé
      Activity? targetActivity = targetExercice.activities.firstWhere(
        (activity) =>
            activity.title.toLowerCase() == activityTitle.toLowerCase(),
        orElse: () => throw Exception('Activity not found'),
      );

      print('Icon URL: ${targetActivity.iconUrl}');
      return targetActivity.iconUrl;
    } catch (e) {
      // Gestion des erreurs - retourner null si l'exercice ou l'activité n'est pas trouvé
      print('Erreur lors de la recherche: $e');
      return null;
    }
  }
}
