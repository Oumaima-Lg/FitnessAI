import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/models/meals.dart';
import 'package:fitness/services/database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

class MealService {
  final String _appId = '52e00a55';
  final String _appKey = 'be82f9624b5dbece605ceb83a2c89705';
  final String _baseUrl = 'https://api.edamam.com/api/recipes/v2';

  // Header pour l’identifiant utilisateur Edamam
  Map<String, String> get _headers => {
        'Edamam-Account-User': 'rhouibi.ibti.fst',
      };

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  // Méthode pour obtenir des repas recommandés
  Future<List<Meal>> getRecommendedMeals() async {
    final params = {
      'type': 'public',
      'app_id': _appId,
      'app_key': _appKey,
      'diet': 'balanced',
      'random': 'true',
      'health': 'alcohol-free',
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hits = data['hits'] as List;

        return hits.map((hit) => Meal.fromEdamamJson(hit)).toList();
      } else {
        throw ApiException(
            'Échec de chargement des repas recommandés: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Erreur lors de la récupération des repas: $e');
    }
  }

  // Méthode pour rechercher des repas
  Future<List<Meal>> searchMeals(String query) async {
    final params = {
      'type': 'public',
      'q': query,
      'app_id': _appId,
      'app_key': _appKey,
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hits = data['hits'] as List;

        return hits.map((hit) => Meal.fromEdamamJson(hit)).toList();
      } else {
        throw ApiException(
            'Échec de la recherche de repas: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Erreur lors de la recherche de repas: $e');
    }
  }

  // Méthode pour obtenir des repas par catégorie
  Future<List<Meal>> getMealsByCategory(String category) async {
    Map<String, Map<String, String>> categoryParams = {
      "Hottest": {"dishType": "main course", "diet": "balanced"},
      "Popular": {"dishType": "salad", "diet": "high-protein"},
      "New combo": {"dishType": "starter", "random": "true"},
      "Top": {"dishType": "dessert", "health": "vegan"}
    };

    final params = {
      'type': 'public',
      'app_id': _appId,
      'app_key': _appKey,
      ...categoryParams[category] ?? {'diet': 'balanced'},
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final hits = data['hits'] as List;

        return hits.map((hit) => Meal.fromEdamamJson(hit)).toList();
      } else {
        throw ApiException(
            'Échec du chargement des repas par catégorie: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Erreur lors de la récupération par catégorie: $e');
    }
  }

  // Méthode pour obtenir les détails d’un repas
  Future<Meal> getMealDetails(String recipeId) async {
    final url = '$_baseUrl/$recipeId';
    final params = {
      'type': 'public',
      'app_id': _appId,
      'app_key': _appKey,
    };

    final uri = Uri.parse(url).replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Meal.fromEdamamJson(data);
      } else {
        throw ApiException(
            'Échec de chargement des détails du repas: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Erreur lors de la récupération des détails: $e');
    }
  }

  // Liste statique pour stocker les repas personnalisés en mémoire
  static List<Meal> _customMeals = [];

  //  Méthode pour sauvegarder un repas personnalisé
  Future<void> saveCustomMeal(Meal meal) async {
    try {
      _customMeals.add(meal);

      // Optionnel : Sauvegarder dans SharedPreferences pour la persistance
      await _saveCustomMealsToPrefs();
    } catch (e) {
      throw ApiException('Erreur lors de la sauvegarde du repas: $e');
    }
  }

  Future<String?> saveCustomMealToFirebase(Meal meal) async {
    try {
      if (_currentUserId == null) {
        throw ApiException('Utilisateur non connecté');
      }

      final mealId = await _databaseMethods.addUserMeal(meal, _currentUserId!);

      if (mealId != null) {
        print('Repas sauvegardé dans Firebase avec l\'ID: $mealId');

        // Optionnel: Aussi sauvegarder localement pour la cache
        await _saveToLocalCache(meal);

        return mealId;
      }

      return null;
    } catch (e) {
      throw ApiException('Erreur lors de la sauvegarde Firebase: $e');
    }
  }

  Future<List<Meal>> getCustomMealsFromFirebase() async {
    try {
      if (_currentUserId == null) {
        throw ApiException('Utilisateur non connecté');
      }

      return await _databaseMethods.getUserCustomMeals(_currentUserId!);
    } catch (e) {
      throw ApiException('Erreur lors de la récupération Firebase: $e');
    }
  }

  Future<List<Meal>> getCombinedRecommendedMeals() async {
    try {
      // Récupérer les repas de l'API
      final apiMeals = await getRecommendedMeals();

      // Récupérer les repas personnalisés depuis Firebase
      List<Meal> customMeals = [];
      if (_currentUserId != null) {
        customMeals = await getCustomMealsFromFirebase();
      }

      // Combiner les listes (max 3 personnalisés + 7 de l'API)
      final combined = <Meal>[];
      combined.addAll(customMeals.take(3));
      combined.addAll(apiMeals.take(7));

      return combined;
    } catch (e) {
      print('Erreur dans getCombinedRecommendedMeals: $e');
      // En cas d'erreur, retourner seulement les repas de l'API
      try {
        return await getRecommendedMeals();
      } catch (apiError) {
        throw ApiException('Impossible de charger les repas: $apiError');
      }
    }
  }

  Future<bool> addToFavorites(Meal meal) async {
    try {
      if (_currentUserId == null) {
        throw ApiException('Utilisateur non connecté');
      }

      return await _databaseMethods.addMealToFavorites(_currentUserId!, meal);
    } catch (e) {
      throw ApiException('Erreur lors de l\'ajout aux favoris: $e');
    }
  }

  Future<List<Meal>> getFavoriteMeals() async {
    try {
      if (_currentUserId == null) {
        throw ApiException('Utilisateur non connecté');
      }

      return await _databaseMethods.getUserFavoriteMeals(_currentUserId!);
    } catch (e) {
      throw ApiException('Erreur lors de la récupération des favoris: $e');
    }
  }

  Future<void> _saveToLocalCache(Meal meal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> cachedMeals =
          prefs.getStringList('cached_custom_meals') ?? [];

      final mealJson = json.encode({
        'label': meal.label,
        'imageUrl': meal.imageUrl,
        'calories': meal.calories,
        'rating': meal.rating,
        'dietLabels': meal.dietLabels,
        'healthLabels': meal.healthLabels,
        'ingredients': meal.ingredients,
        'mealType': meal.mealType,
      });

      cachedMeals.add(mealJson);
      await prefs.setStringList('cached_custom_meals', cachedMeals);
    } catch (e) {
      print('Erreur lors de la sauvegarde en cache: $e');
    }
  }

  Future<List<Meal>> getCachedCustomMeals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> cachedMeals =
          prefs.getStringList('cached_custom_meals') ?? [];

      return cachedMeals.map((mealJson) {
        final data = json.decode(mealJson);
        return Meal(
          label: data['label'] ?? '',
          imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/120',
          calories: (data['calories'] ?? 0.0).toDouble(),
          rating: (data['rating'] ?? 4.5).toDouble(),
          dietLabels: List<String>.from(data['dietLabels'] ?? []),
          healthLabels: List<String>.from(data['healthLabels'] ?? []),
          ingredients: List<String>.from(data['ingredients'] ?? []),
          mealType: data['mealType'] ?? 'Meal',
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération du cache: $e');
      return [];
    }
  }

  Future<void> clearLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_custom_meals');
    } catch (e) {
      print('Erreur lors du vidage du cache: $e');
    }
  }

  // Méthode pour obtenir les repas personnalisés
  Future<List<Meal>> getCustomMeals() async {
    try {
      // Charger depuis SharedPreferences au premier appel
      if (_customMeals.isEmpty) {
        await _loadCustomMealsFromPrefs();
      }
      return _customMeals;
    } catch (e) {
      throw ApiException(
          'Erreur lors de la récupération des repas personnalisés: $e');
    }
  }

  // Méthode pour combiner repas API et personnalisés
  // Future<List<Meal>> getCombinedRecommendedMeals() async {
  //   try {
  //     final apiMeals = await getRecommendedMeals();
  //     final customMeals = await getCustomMeals();

  //     // Mélanger les repas (max 3 personnalisés)
  //     final combined = <Meal>[];
  //     combined.addAll(customMeals.take(3));
  //     combined
  //         .addAll(apiMeals.take(7)); // Garder 7 de l'API pour un total de 10

  //     return combined;
  //   } catch (e) {
  //     // En cas d'erreur, retourner seulement les repas de l'API
  //     return await getRecommendedMeals();
  //   }
  // }

  // Sauvegarder les repas personnalisés dans SharedPreferences
  Future<void> _saveCustomMealsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mealsJson = _customMeals
          .map((meal) => {
                'label': meal.label,
                'imageUrl': meal.imageUrl,
                'calories': meal.calories,
                'rating': meal.rating,
                'dietLabels': meal.dietLabels,
                'healthLabels': meal.healthLabels,
                'ingredients': meal.ingredients,
                'mealType': meal.mealType,
              })
          .toList();

      await prefs.setString('custom_meals', json.encode(mealsJson));
    } catch (e) {
      print('Erreur lors de la sauvegarde des repas personnalisés: $e');
    }
  }

  // Charger les repas personnalisés depuis SharedPreferences
  Future<void> _loadCustomMealsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mealsJsonString = prefs.getString('custom_meals');

      if (mealsJsonString != null) {
        final mealsJson = json.decode(mealsJsonString) as List;
        _customMeals = mealsJson
            .map((mealData) => Meal(
                  label: mealData['label'] ?? '',
                  imageUrl:
                      mealData['imageUrl'] ?? 'https://via.placeholder.com/120',
                  calories: (mealData['calories'] ?? 0.0).toDouble(),
                  rating: (mealData['rating'] ?? 4.5).toDouble(),
                  dietLabels: List<String>.from(mealData['dietLabels'] ?? []),
                  healthLabels:
                      List<String>.from(mealData['healthLabels'] ?? []),
                  ingredients: List<String>.from(mealData['ingredients'] ?? []),
                  mealType: mealData['mealType'] ?? 'Meal',
                ))
            .toList();
      }
    } catch (e) {
      print('Erreur lors du chargement des repas personnalisés: $e');
      _customMeals = []; // Initialiser avec une liste vide en cas d'erreur
    }
  }

  // Méthode pour supprimer un repas personnalisé
  Future<void> deleteCustomMeal(Meal meal) async {
    try {
      _customMeals.removeWhere((m) =>
          m.label == meal.label &&
          m.imageUrl == meal.imageUrl &&
          m.calories == meal.calories);
      await _saveCustomMealsToPrefs();
    } catch (e) {
      throw ApiException('Erreur lors de la suppression du repas: $e');
    }
  }

  // Méthode pour vérifier si un repas est personnalisé
  bool isCustomMeal(Meal meal) {
    return _customMeals.any((m) =>
        m.label == meal.label &&
        m.imageUrl == meal.imageUrl &&
        m.calories == meal.calories);
  }
}
