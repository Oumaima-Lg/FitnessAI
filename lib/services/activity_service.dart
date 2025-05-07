import 'dart:convert';
import 'package:fitness/models/activity.dart';
import 'package:http/http.dart' as http;

class ActivityService {
  static const String baseUrl = 'https://exercisedb.p.rapidapi.com/exercises';

  static Future<List<Activity>> fetchGymActivities() async {
    final url = Uri.parse('$baseUrl?limit=50');

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': '0a02f9e3bemsh269a8d1d2418c9bp145b73jsn7e40e4490d6f',
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
