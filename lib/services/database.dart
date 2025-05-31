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

  // hna ajoutena wahd sous collection ldak l user :
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


  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      
      print('User details retrieved: ${doc.data()}');
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

// Future getUserByUserName(String userName) async {
//     return await FirebaseFirestore.instance
//         .collection("users")
//         .where("name", isEqualTo: userName)
//         .get();
//   }
  // Future getUserByUserName(String userName) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("name", isEqualTo: userName)
  //       .get();
  // }

  // Future getUserByUserEmail(String userEmail) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: userEmail)
  //       .get();
  // }

  // Future getUserById(String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(id)
  //       .get();
  // }
}
