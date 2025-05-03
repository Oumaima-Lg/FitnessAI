import 'package:fitness/models/activity.dart';

class Exercice {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  List<Activity> activities;

  Exercice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.activities,
  });
}
