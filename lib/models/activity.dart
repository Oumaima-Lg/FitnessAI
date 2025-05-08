import 'package:fitness/models/step.dart';

class Activity {
  String id;
  String title;
  String iconUrl;
  String? imageUrl;
  String? description;
  List<String>? techniques;
  String? muscleImageUrl;
  String? muscleDescription;
  String? videoDemonstartionUrl;
  String? bodyPart;
  String? equipment;
  String? target;
  List<String>? secondaryMuscles;
  List<StepItem>? steps;

  Activity({
    required this.id,
    required this.title,
    required this.iconUrl,
    this.imageUrl,
    this.description,
    this.techniques,
    this.muscleImageUrl,
    this.muscleDescription,
    this.videoDemonstartionUrl,
    this.bodyPart,
    this.equipment,
    this.target,
    this.secondaryMuscles,
    this.steps,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      iconUrl: json['gifUrl'],
      videoDemonstartionUrl: json['gifUrl'],
      title: json['name'],
      imageUrl: json['gifUrl'],
      bodyPart: json['bodyPart'],
      equipment: json['equipment'],
      target: json['target'],
      secondaryMuscles: List<String>.from(json['secondaryMuscles']),
      techniques: List<String>.from(json['instructions']),
      description: 'Target muscle: ${json['target']}',
    );
  }
}
