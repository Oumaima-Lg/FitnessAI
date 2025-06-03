import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/meals.dart';

class DatabaseMethods {
  // methode li kat ajouter user details f database (firebase):
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

  Future<bool> updateUserDetails(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update(updatedData);

      print("user data mis à jour avec succès dans Firestore");
      return true;
    } catch (e) {
      print("Erreur lors de la mise à jour du user data dans Firestore: $e");
      return false;
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

  Future addUserMealPlanningDetails(
      Map<String, dynamic> userPlanningMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("MealsPlanning")
        .add(userPlanningMap);
  }

  Future<String?> addUserMeal(Meal meal, String userId) async {
    try {
      Map<String, dynamic> mealData = {
        'label': meal.label,
        'imageUrl': meal.imageUrl,
        'calories': meal.calories,
        'rating': meal.rating,
        'dietLabels': meal.dietLabels,
        'healthLabels': meal.healthLabels,
        'ingredients': meal.ingredients,
        'mealType': meal.mealType,
        'isCustom': true,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
      };
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Meals")
          .add(mealData);

      print('Repas ajouté avec succès. ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Erreur lors de l\'ajout du repas: $e');
      throw Exception('Impossible d\'ajouter le repas: $e');
    }
  }

  Future<List<Meal>> getUserCustomMeals(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("Meals")
          .where("isCustom", isEqualTo: true)
          .orderBy("createdAt", descending: true)
          .get();

      List<Meal> meals = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Meal meal = Meal(
          label: data['label'] ?? '',
          imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/120',
          calories: (data['calories'] ?? 0.0).toDouble(),
          rating: (data['rating'] ?? 4.5).toDouble(),
          dietLabels: List<String>.from(data['dietLabels'] ?? []),
          healthLabels: List<String>.from(data['healthLabels'] ?? []),
          ingredients: List<String>.from(data['ingredients'] ?? []),
          mealType: data['mealType'] ?? 'Meal',
        );

        meals.add(meal);
      }

      return meals;
    } catch (e) {
      print('Erreur lors de la récupération des repas: $e');
      return [];
    }
  }

  Future<bool> addMealToFavorites(String userId, Meal meal) async {
    try {
      Map<String, dynamic> favoriteData = {
        'label': meal.label,
        'imageUrl': meal.imageUrl,
        'calories': meal.calories,
        'rating': meal.rating,
        'dietLabels': meal.dietLabels,
        'healthLabels': meal.healthLabels,
        'ingredients': meal.ingredients,
        'mealType': meal.mealType,
        'isFavorite': true,
        'addedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("FavoriteMeals")
          .add(favoriteData);

      return true;
    } catch (e) {
      print('Erreur lors de l\'ajout aux favoris: $e');
      return false;
    }
  }

  Future<List<Meal>> getUserFavoriteMeals(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("FavoriteMeals")
          .orderBy("addedAt", descending: true)
          .get();

      List<Meal> favoriteMeals = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Meal meal = Meal(
          label: data['label'] ?? '',
          imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/120',
          calories: (data['calories'] ?? 0.0).toDouble(),
          rating: (data['rating'] ?? 4.5).double(),
          dietLabels: List<String>.from(data['dietLabels'] ?? []),
          healthLabels: List<String>.from(data['healthLabels'] ?? []),
          ingredients: List<String>.from(data['ingredients'] ?? []),
          mealType: data['mealType'] ?? 'Meal',
        );

        favoriteMeals.add(meal);
      }

      return favoriteMeals;
    } catch (e) {
      print('Erreur lors de la récupération des favoris: $e');
      return [];
    }
  }

  // Future<Map<String, dynamic>?> getUserDetails(String userId) async {
  //   try {
  //     DocumentSnapshot doc = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(userId)
  //         .get();

  //     print('User details retrieved: ${doc.data()}');

  //     if (doc.exists) {
  //       return doc.data() as Map<String, dynamic>?;
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Erreur lors de la récupération des données utilisateur: $e');
  //     return null;
  //   }
  // }

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
