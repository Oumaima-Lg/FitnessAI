import 'dart:convert';
import 'package:fitness/models/activity.dart';
import 'package:http/http.dart' as http;

class ActivityService {
  static const String baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';

  static Future<List<Activity>> fetchGymActivities() async {
    final url = Uri.parse('$baseUrl?limit=10');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': '343199d5b5mshc3098cffd6d261bp1ba214jsn5509d86c8d76',
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
