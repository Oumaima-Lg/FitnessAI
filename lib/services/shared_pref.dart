import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness/models/planning.dart';

class SharedpreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";
  static String userPlanningKey = "USERPLANNINGKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Sauvegarder la liste complète des plannings
  Future<bool> savePlanningList(List<PlanningModel> plannings) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> planningJsonList =
          plannings.map((planning) => planning.toJson()).toList();
      return await prefs.setStringList(userPlanningKey, planningJsonList);
    } catch (e) {
      print('Erreur lors de la sauvegarde des plannings: $e');
      return false;
    }
  }

  // Récupérer la liste des plannings
  Future<List<PlanningModel>> getPlanningList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? planningJsonList = prefs.getStringList(userPlanningKey);

      if (planningJsonList == null) return [];

      return planningJsonList
          .map((planningJson) => PlanningModel.fromJson(planningJson))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des plannings: $e');
      return [];
    }
  }

  // Ajouter un nouveau planning à la liste existante
  Future<bool> addPlanning(PlanningModel planning) async {
    try {
      List<PlanningModel> currentPlannings = await getPlanningList();

      // Vérifier si le planning existe déjà (basé sur l'ID)
      int existingIndex =
          currentPlannings.indexWhere((p) => p.id == planning.id);

      if (existingIndex != -1) {
        // Remplacer le planning existant
        currentPlannings[existingIndex] = planning;
      } else {
        // Ajouter le nouveau planning
        currentPlannings.add(planning);
      }

      // Trier par date/heure (les plus récents en premier)
      currentPlannings.sort((a, b) => b.selectedTime.compareTo(a.selectedTime));

      return await savePlanningList(currentPlannings);
    } catch (e) {
      print('Erreur lors de l\'ajout du planning: $e');
      return false;
    }
  }

  // Supprimer un planning par ID
  Future<bool> removePlanning(String planningId) async {
    try {
      List<PlanningModel> currentPlannings = await getPlanningList();
      currentPlannings.removeWhere((planning) => planning.id == planningId);
      return await savePlanningList(currentPlannings);
    } catch (e) {
      print('Erreur lors de la suppression du planning: $e');
      return false;
    }
  }

  // Mettre à jour un planning existant
  Future<bool> updatePlanning(PlanningModel updatedPlanning) async {
    try {
      List<PlanningModel> currentPlannings = await getPlanningList();
      int index =
          currentPlannings.indexWhere((p) => p.id == updatedPlanning.id);

      if (index != -1) {
        currentPlannings[index] = updatedPlanning;
        return await savePlanningList(currentPlannings);
      }
      return false;
    } catch (e) {
      print('Erreur lors de la mise à jour du planning: $e');
      return false;
    }
  }

  // Récupérer les plannings pour une date spécifique
  Future<List<PlanningModel>> getPlanningsForDate(DateTime date) async {
    try {
      List<PlanningModel> allPlannings = await getPlanningList();
      return allPlannings.where((planning) {
        return planning.selectedTime.year == date.year &&
            planning.selectedTime.month == date.month &&
            planning.selectedTime.day == date.day;
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des plannings pour la date: $e');
      return [];
    }
  }

  // Récupérer les plannings à venir (futurs)
  Future<List<PlanningModel>> getUpcomingPlannings() async {
    try {
      List<PlanningModel> allPlannings = await getPlanningList();
      DateTime now = DateTime.now();
      return allPlannings
          .where((planning) => planning.selectedTime.isAfter(now))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des plannings à venir: $e');
      return [];
    }
  }

  // Compter le nombre total de plannings
  Future<int> getPlanningCount() async {
    try {
      List<PlanningModel> plannings = await getPlanningList();
      return plannings.length;
    } catch (e) {
      print('Erreur lors du comptage des plannings: $e');
      return 0;
    }
  }

  // Compter le nombre total de plannings
  Future<int> getPlanningTodayCount() async {
    try {
      List<PlanningModel> plannings = await getPlanningsForDate(DateTime.now());
      return plannings.length;
    } catch (e) {
      print('Erreur lors du comptage des plannings: $e');
      return 0;
    }
  }

  // Vider tous les plannings
  Future<bool> clearAllPlannings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(userPlanningKey);
    } catch (e) {
      print('Erreur lors de la suppression de tous les plannings: $e');
      return false;
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userImageKey);
    await prefs.remove(userPlanningKey);
  }
}
