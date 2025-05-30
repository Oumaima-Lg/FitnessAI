import 'dart:convert';
import 'package:fitness/models/meals.dart';
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

  // Ajoutez ces méthodes à votre classe MealService existante

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
  Future<List<Meal>> getCombinedRecommendedMeals() async {
    try {
      final apiMeals = await getRecommendedMeals();
      final customMeals = await getCustomMeals();

      // Mélanger les repas (max 3 personnalisés)
      final combined = <Meal>[];
      combined.addAll(customMeals.take(3));
      combined
          .addAll(apiMeals.take(7)); // Garder 7 de l'API pour un total de 10

      return combined;
    } catch (e) {
      // En cas d'erreur, retourner seulement les repas de l'API
      return await getRecommendedMeals();
    }
  }

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
