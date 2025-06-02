import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/meals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/planning/AddMealSchedule.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';

class MealPlanningService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  // Ajouter un repas planifié
  Future<void> addPlannedMeal({
    required DateTime date,
    required TimeOfDay time,
    required String mealType,
    required List<MealItem> items,
    required double totalCalories,
    required double totalProteins,
    required double totalCarbs,
    required double totalFats,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final formattedDate = DateTime(date.year, date.month, date.day);
      final formattedTime = '${time.hour}:${time.minute}';

      final data = {
        'date': Timestamp.fromDate(formattedDate),
        'time': formattedTime,
        'mealType': mealType,
        'items': items.map((item) => _mealItemToMap(item)).toList(),
        'totalCalories': totalCalories,
        'totalProteins': totalProteins,
        'totalCarbs': totalCarbs,
        'totalFats': totalFats,
        'createdAt': FieldValue.serverTimestamp(),
      };

      _databaseMethods.addUserMealPlanningDetails(data, userId);
    } catch (e) {
      print('Erreur lors de l\'ajout du repas planifié: $e');
      throw Exception('Impossible d\'ajouter le repas planifié: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPlannedMealsForDate(
      DateTime date) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('MealsPlanning')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .orderBy('time')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'time': data['time'],
          'mealType': data['mealType'],
          'items': data['items'] ?? [],
          'totalCalories': data['totalCalories'],
          'totalProteins': data['totalProteins'],
          'totalCarbs': data['totalCarbs'],
          'totalFats': data['totalFats'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching planned meals: $e');
      return [];
    }
  }

  // Nouvelle méthode pour obtenir les MealItems (si nécessaire)
  Future<List<Map<String, dynamic>>> getPlannedMealsWithMealItems(
      DateTime date) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('MealsPlanning')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .orderBy('time')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'time': data['time'],
          'mealType': data['mealType'],
          'items': _parseMealItems(data['items'] ?? []), // Convertit en MealItems
          'totalCalories': data['totalCalories'],
          'totalProteins': data['totalProteins'],
          'totalCarbs': data['totalCarbs'],
          'totalFats': data['totalFats'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching planned meals with MealItems: $e');
      return [];
    }
  }

  Map<String, dynamic> _mealItemToMap(MealItem item) {
    return {
      'label': item.meal.label,
      'imageUrl': item.meal.imageUrl,
      'calories': item.meal.calories,
      'quantity': item.quantity,
      'totalCalories': item.totalCalories,
      'totalProteins': item.totalProteins,
      'totalCarbs': item.totalCarbs,
      'totalFats': item.totalFats,
      // Ajout des autres propriétés du meal
      'rating': item.meal.rating,
      'dietLabels': item.meal.dietLabels,
      'healthLabels': item.meal.healthLabels,
      'ingredients': item.meal.ingredients,
      'mealType': item.meal.mealType,
    };
  }

  List<MealItem> _parseMealItems(List<dynamic> itemsData) {
    return itemsData.map((itemData) {
      // Vérification que itemData est bien un Map
      if (itemData is! Map<String, dynamic>) {
        print('Warning: itemData is not a Map: $itemData');
        return null;
      }

      final meal = Meal(
        label: itemData['label'] ?? '',
        imageUrl: itemData['imageUrl'] ?? '',
        calories: (itemData['calories'] ?? 0.0).toDouble(),
        rating: (itemData['rating'] ?? 4.5).toDouble(),
        dietLabels: List<String>.from(itemData['dietLabels'] ?? []),
        healthLabels: List<String>.from(itemData['healthLabels'] ?? []),
        ingredients: List<String>.from(itemData['ingredients'] ?? []),
        mealType: itemData['mealType'] ?? '',
      );

      return MealItem(
        meal: meal,
        quantity: (itemData['quantity'] ?? 1.0).toDouble(),
      );
    }).where((item) => item != null).cast<MealItem>().toList();
  }

  
}