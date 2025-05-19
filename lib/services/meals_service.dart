import 'dart:convert';
import 'package:fitness/models/meals.dart';
import 'package:http/http.dart' as http;

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

  // 🔐 Header pour l’identifiant utilisateur Edamam
  Map<String, String> get _headers => {
        'Edamam-Account-User': 'rhouibi.ibti.fst',
      };

  // ✅ Méthode pour obtenir des repas recommandés
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

  // ✅ Méthode pour rechercher des repas
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

  // ✅ Méthode pour obtenir des repas par catégorie
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

  // ✅ Méthode pour obtenir les détails d’un repas
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
}
