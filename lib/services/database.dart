import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
      return null;
    }
  }

  Future addUserWorkoutDetails(
      Map<String, dynamic> userPlanningMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("workoutPlanning")
        .add(userPlanningMap);
  }

  Future<List<Map<String, dynamic>>> getUserWorkoutDetails(
      String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("workoutPlanning")
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Erreur lors de la récupération des détails d'entraînement: $e");
      return [];
    }
  }

// Nouvelle méthode pour mettre à jour un workout existant
  Future<bool> updateUserWorkoutDetails(String userId, String documentId,
      Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("workoutPlanning")
          .doc(documentId)
          .update(updatedData);

      print("Workout mis à jour avec succès dans Firestore");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour du workout dans Firestore: $e");
      return false;
    }
  }

  // Méthode pour trouver un workout par critères spécifiques
  Future<String?> findWorkoutDocumentId(
      String userId, String selectedWorkout, String selectedActivity) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("workoutPlanning")
          .where("selectedWorkout", isEqualTo: selectedWorkout)
          .where("selectedActivity", isEqualTo: selectedActivity)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      print("Erreur lors de la recherche du document workout: $e");
      return null;
    }
  }
}
