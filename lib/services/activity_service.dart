import 'dart:convert';
import 'package:fitness/models/activity.dart';
import 'package:http/http.dart' as http;

class ActivityService {
  static const String baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';

  static Future<List<Activity>> fetchGymActivities() async {
    final url = Uri.parse('$baseUrl?limit=0');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': 'faebe86a44mshfa5070c27d73bd4p13e1e9jsn017ffde9ff90',
        'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des activités');
    }
  }
}
