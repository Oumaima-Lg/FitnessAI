import 'dart:convert';

class PlanningModel {
  final String id;
  final String selectedWorkout;
  final String selectedActivity;
  final String description;
  final DateTime selectedTime;
  final DateTime createdAt;
  final String activityIconUrl;
  final String userId;

  bool isCompleted;
  DateTime? completedAt;

  PlanningModel({
    required this.id,
    required this.selectedWorkout,
    required this.selectedActivity,
    required this.description,
    required this.selectedTime,
    required this.createdAt,
    required this.activityIconUrl,
    required this.userId,
    this.isCompleted = false, // Par défaut, l'activité n'est pas complétée
    this.completedAt,
  });

  // Factory constructor pour créer depuis une Map
  factory PlanningModel.fromMap(Map<String, dynamic> map) {
    return PlanningModel(
      id: map['id'] ?? '',
      selectedWorkout: map['selectedWorkout'] ?? '',
      selectedActivity: map['selectedActivity'] ?? '',
      description: map['description'] ?? '',
      selectedTime: DateTime.parse(map['selectedTime']),
      createdAt: DateTime.parse(map['createdAt']),
      activityIconUrl: map['activityIconUrl'] ?? '',
      userId: map['userId'] ?? '',
      // CORRECTION : Gestion sécurisée des nouveaux champs
      isCompleted: map['isCompleted'] ?? false,
      completedAt:
          map['completedAt'] != null && map['completedAt'].toString().isNotEmpty
              ? DateTime.parse(map['completedAt'])
              : null,
    );
  }

  // Convertir en Map pour le stockage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'selectedWorkout': selectedWorkout,
      'selectedActivity': selectedActivity,
      'description': description,
      'selectedTime': selectedTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'activityIconUrl': activityIconUrl,
      'userId': userId,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  // Factory constructor depuis JSON string
  factory PlanningModel.fromJson(String source) {
    return PlanningModel.fromMap(json.decode(source));
  }

  // Convertir en JSON string
  String toJson() => json.encode(toMap());

  // Méthode copyWith pour créer une copie modifiée
  PlanningModel copyWith({
    String? id,
    String? selectedWorkout,
    String? selectedActivity,
    String? description,
    DateTime? selectedTime,
    DateTime? createdAt,
    String? activityIconUrl,
    String? userId,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return PlanningModel(
      id: id ?? this.id,
      selectedWorkout: selectedWorkout ?? this.selectedWorkout,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      description: description ?? this.description,
      selectedTime: selectedTime ?? this.selectedTime,
      createdAt: createdAt ?? this.createdAt,
      activityIconUrl: activityIconUrl ?? this.activityIconUrl,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Getters utiles pour l'affichage
  String get formattedDate {
    return "${selectedTime.day.toString().padLeft(2, '0')}/${selectedTime.month.toString().padLeft(2, '0')}/${selectedTime.year}";
  }

  String get formattedTime {
    int hour = selectedTime.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return "${hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')} $period";
  }

  String get formattedDateTime {
    return "$formattedDate à $formattedTime";
  }

  @override
  String toString() {
    return 'PlanningModel(id: $id, workout: $selectedWorkout, activity: $selectedActivity, time: $formattedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlanningModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
