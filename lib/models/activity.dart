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
    this.steps,
  });

  // factory Activity.fromJson(Map<String, dynamic> json) {
  //   return Activity(
  //     id: json['id'] as String?,
  //     title: json['title'] as String?,
  //     iconUrl: json['iconUrl'] as String?,
  //     imageUrl: json['imageUrl'] as String?,
  //     description: json['description'] as String?,
  //     techniques: (json['techniques'] as List<dynamic>?)?.map((e) => e as String).toList(),
  //     muscleImageUrl: json['muscleImageUrl'] as String?,
  //     muscleDescription: json['muscleDescription'] as String?,
  //     videoDemonstartionUrl: json['videoDemonstartionUrl'] as String?,

  //   );
  // }
}
