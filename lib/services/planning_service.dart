import 'package:fitness/models/planning.dart';
import 'package:fitness/services/shared_pref.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';

class PlanningService {
  static final SharedpreferenceHelper _sharedPref = SharedpreferenceHelper();

  static PlanningModel createPlanningModel({
    required String id,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required String selectedWorkout,
    required String selectedActivity,
    required String description,
    required String activityIconUrl,
    required String userId,
  }) {
    DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    return PlanningModel(
      id: id,
      selectedWorkout: selectedWorkout,
      selectedActivity: selectedActivity,
      description: description,
      selectedTime: selectedDateTime,
      createdAt: DateTime.now(),
      activityIconUrl: activityIconUrl,
      userId: userId,
    );
  }

  // Sauvegarder un planning (Firestore + SharedPreferences)
  static Future<bool> savePlanning(PlanningModel planning) async {
    try {
      // Sauvegarder dans Firestore
      await DatabaseMethods()
          .addUserWorkoutDetails(planning.toMap(), planning.userId);

      // Sauvegarder localement
      bool localSaved = await _sharedPref.addPlanning(planning);

      return localSaved;
    } catch (e) {
      print('Erreur lors de la sauvegarde du planning: $e');
      return false;
    }
  }

  static Future<List<PlanningModel>> getAllPlannings() async {
    return await _sharedPref.getPlanningList();
  }

  // Récupérer les plannings pour aujourd'hui
  static Future<List<PlanningModel>> getTodayPlannings() async {
    return await _sharedPref.getPlanningsForDate(DateTime.now());
  }

  // Récupérer les plannings à venir
  static Future<List<PlanningModel>> getUpcomingPlannings() async {
    return await _sharedPref.getUpcomingPlannings();
  }

  // Supprimer un planning
  static Future<bool> deletePlanning(String planningId) async {
    return await _sharedPref.removePlanning(planningId);
  }

  static Future<int> getPlanningCount() async {
    return await _sharedPref.getPlanningCount();
  }

  static Future<int> getPlanningTodayCount() async {
    return await _sharedPref.getPlanningTodayCount();
  }

  // static Future<int> markActivityAsCompleted(
  //     String titleExercice, String activityTitle) async {
  //   try {
  //     // Récupérer les plannings d'aujourd'hui
  //     List<PlanningModel> todayPlannings = await getTodayPlannings();

  //     int completedActivitiesCount = 0;
  //     bool foundActivity = false;

  //     // Parcourir tous les plannings d'aujourd'hui
  //     for (int i = 0; i < todayPlannings.length; i++) {
  //       PlanningModel planning = todayPlannings[i];

  //       // Vérifier si ce planning correspond à l'activité en cours
  //       bool isMatchingActivity = planning.selectedWorkout.toLowerCase() ==
  //               titleExercice.toLowerCase() &&
  //           planning.selectedActivity.toLowerCase() ==
  //               activityTitle.toLowerCase();

  //       if (isMatchingActivity && !planning.isCompleted) {
  //         // Marquer cette activité comme complétée
  //         planning.isCompleted = true;
  //         planning.completedAt = DateTime.now();

  //         // Mettre à jour le planning dans SharedPreferences
  //         await _sharedPref.updatePlanning(planning);
  //         foundActivity = true;

  //         print(
  //             'Activité marquée comme complétée: ${planning.selectedWorkout} - ${planning.selectedActivity}');
  //       }

  //       // Compter toutes les activités complétées
  //       if (planning.isCompleted) {
  //         completedActivitiesCount++;
  //       }
  //     }

  //     if (foundActivity) {
  //       print(
  //           'Total d\'activités complétées aujourd\'hui: $completedActivitiesCount');
  //     } else {
  //       print(
  //           'Activité non trouvée dans le planning: $titleExercice - $activityTitle');
  //     }

  //     return completedActivitiesCount;
  //   } catch (e) {
  //     print('Erreur lors de la mise à jour de l\'activité: $e');
  //     return 0;
  //   }
  // }

  static Future<int> markActivityAsCompleted(
      String titleExercice, String activityTitle) async {
    try {
      // Récupérer les plannings d'aujourd'hui
      List<PlanningModel> todayPlannings = await getTodayPlannings();

      int completedActivitiesCount = 0;
      bool foundActivity = false;

      // Parcourir tous les plannings d'aujourd'hui
      for (int i = 0; i < todayPlannings.length; i++) {
        PlanningModel planning = todayPlannings[i];

        // Vérifier si ce planning correspond à l'activité en cours
        bool isMatchingActivity = planning.selectedWorkout.toLowerCase() ==
                titleExercice.toLowerCase() &&
            planning.selectedActivity.toLowerCase() ==
                activityTitle.toLowerCase();

        if (isMatchingActivity && !planning.isCompleted) {
          // Marquer cette activité comme complétée
          planning.isCompleted = true;
          planning.completedAt = DateTime.now();

          // Mettre à jour le planning dans SharedPreferences
          await _sharedPref.updatePlanning(planning);

          // NOUVEAU : Mettre à jour dans Firestore
          try {
            // Trouver le document ID dans Firestore
            String? documentId = await DatabaseMethods().findWorkoutDocumentId(
              planning.userId,
              planning.selectedWorkout,
              planning.selectedActivity,
            );

            if (documentId != null) {
              // Mettre à jour le document dans Firestore
              Map<String, dynamic> updateData = {
                'isCompleted': true,
                'completedAt': DateTime.now().toIso8601String(),
              };

              bool firestoreUpdated = await DatabaseMethods()
                  .updateUserWorkoutDetails(
                      planning.userId, documentId, updateData);

              if (firestoreUpdated) {
                print('Activité mise à jour dans Firestore avec succès');
              } else {
                print('Échec de la mise à jour dans Firestore');
              }
            } else {
              print('Document non trouvé dans Firestore pour cette activité');
            }
          } catch (firestoreError) {
            print('Erreur lors de la mise à jour Firestore: $firestoreError');
            // On continue même si Firestore échoue, car SharedPreferences est déjà mis à jour
          }

          foundActivity = true;
          print(
              'Activité marquée comme complétée: ${planning.selectedWorkout} - ${planning.selectedActivity}');
        }

        // Compter toutes les activités complétées
        if (planning.isCompleted) {
          completedActivitiesCount++;
        }
      }

      if (foundActivity) {
        print(
            'Total d\'activités complétées aujourd\'hui: $completedActivitiesCount');
      } else {
        print(
            'Activité non trouvée dans le planning: $titleExercice - $activityTitle');
      }

      return completedActivitiesCount;
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'activité: $e');
      return 0;
    }
  }

  /// Récupérer le nombre d'activités complétées aujourd'hui
  static Future<int> getCompletedActivitiesCountToday() async {
    try {
      List<PlanningModel> todayPlannings = await getTodayPlannings();
      return todayPlannings.where((planning) => planning.isCompleted).length;
    } catch (e) {
      print('Erreur lors du comptage des activités complétées: $e');
      return 0;
    }
  }

  /// Récupérer le pourcentage de progression pour aujourd'hui
  static Future<double> getTodayProgressPercentage() async {
    try {
      List<PlanningModel> todayPlannings = await getTodayPlannings();
      if (todayPlannings.isEmpty) return 0.0;

      int completedCount =
          todayPlannings.where((planning) => planning.isCompleted).length;
      return (completedCount / todayPlannings.length) * 100;
    } catch (e) {
      print('Erreur lors du calcul du pourcentage: $e');
      return 0.0;
    }
  }
}
