class PlanningService {
  static Map<String, dynamic> createUserPlanningMap(selectedDate, selectedTime,
      selectedWorkout, selectedActivity, descriptionController) {
    // Création de la date complète avec l'heure sélectionnée
    DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    return {
      "selectedWorkout": selectedWorkout,
      "selectedActivity": selectedActivity,
      "description": descriptionController.text,
      "selectedTime": selectedDateTime.toIso8601String(),
      "createdAt": DateTime.now().toIso8601String(),
    };
  }
}
