import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/return_button.dart';
import 'package:fitness/data/exercice_data.dart';
import 'package:fitness/models/exercice.dart';
import 'package:fitness/models/planning.dart';
import 'package:fitness/pages/planning/WorkoutSavedScreen.dart';
import 'package:fitness/services/database.dart';
import 'package:fitness/services/exercice_service.dart';
import 'package:fitness/services/planning_service.dart';
import 'package:fitness/services/shared_pref.dart';
import 'package:flutter/material.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  late TimeOfDay selectedTime;
  late DateTime selectedDate;
  late String selectedWorkout;
  late int indexWorkout;
  late String selectedActivity;
  final TextEditingController descriptionController = TextEditingController();
  List<Exercice> exercices = [];

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
    selectedDate = DateTime.now();
    loadData();
  }

  void loadData() async {
    List<Exercice> data = await ExerciceData.getExercices();
    setState(() {
      exercices = data;
      selectedWorkout = exercices[0].title;
      indexWorkout = 0;
      selectedActivity = exercices[0].activities[0].title;
    });

    // exercices = ExerciceData.getExercices();
  }

  String _formatDate(DateTime date) {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Correction de l'indice du jour de la semaine (weekday dans DateTime va de 1-7, où 1=lundi)
    int weekdayIndex = date.weekday - 1;
    if (weekdayIndex < 0 || weekdayIndex >= weekdays.length) {
      weekdayIndex = 0; // Valeur par défaut au cas où
    }

    String weekday = weekdays[weekdayIndex];
    String month = months[date.month - 1];
    int day = date.day;
    int year = date.year;

    return '$weekday, $day $month $year';
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF343B67),
              onPrimary: Colors.white,
              surface: Color(0xFF2A2D4A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF2A2D4A),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF92A3FD),
              onPrimary: Colors.white,
              surface: Color(0xFF2A2D4A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF2A2D4A),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (exercices.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Image.asset('images/gif/Animation.gif')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2A2D4A),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header with back button
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Color(0xFFE8ACFF).withAlpha(178)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 16),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 86),
                    const Text(
                      'Add Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Date selection
                GestureDetector(
                  onTap: _selectDate,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color.fromARGB(255, 235, 173, 156), size: 14),
                      const SizedBox(width: 8),
                      GradientTitleText(
                        text: _formatDate(selectedDate),
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Time label
                const Text(
                  'Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                // Time picker
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade700),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hour picker
                        buildNumberColumn(
                          current: selectedTime.hour % 12 == 0
                              ? 12
                              : selectedTime.hour % 12,
                          prev: selectedTime.hour % 12 == 1
                              ? 12
                              : (selectedTime.hour % 12) - 1,
                          next: selectedTime.hour % 12 == 12
                              ? 1
                              : (selectedTime.hour % 12) + 1,
                        ),
                        const Text(":",
                            style: TextStyle(
                                color: Color(0xFF92A3FD), fontSize: 20)),
                        // Minute picker
                        buildNumberColumn(
                          current: selectedTime.minute,
                          prev: selectedTime.minute == 0
                              ? 59
                              : selectedTime.minute - 1,
                          next: selectedTime.minute == 59
                              ? 0
                              : selectedTime.minute + 1,
                          showAsDoubleDigit: true,
                        ),
                        const SizedBox(width: 16),
                        // AM/PM picker
                        Text(
                          selectedTime.period == DayPeriod.am ? "AM" : "PM",
                          style: TextStyle(
                            color: Color(0xFF92A3FD),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Details Workout
                const Text(
                  'Workout Details ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Choose Workout button
                buildSelectionCard(
                  icon: Icons.fitness_center,
                  title: 'Choose Workout',
                  value: selectedWorkout,
                  valueColor: Colors.red,
                  onTap: () {
                    // Ouvrir une boîte de dialogue pour sélectionner un workout
                    _showWorkoutSelectionDialog();
                  },
                ),
                const SizedBox(height: 16),

                // Activity button
                buildSelectionCard(
                  icon: Icons.directions_run,
                  title: 'Activity',
                  value: selectedActivity,
                  valueColor: Colors.red,
                  onTap: () {
                    // Ouvrir une boîte de dialogue pour sélectionner une activité
                    _showActivitySelectionDialog();
                  },
                ),
                const SizedBox(height: 16),

                // Description
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF92A3FD).withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description_outlined,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          hintText: 'Enter description...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                ReturnButton.gradientButton('Save',
                    onPressed: () => _saveSchedule()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWorkoutSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF343B67),
        title:
            const Text('Select Workout', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: exercices.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(exercices[index].title,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    selectedWorkout = exercices[index].title;
                    indexWorkout = index;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showActivitySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF343B67),
        title: const Text('Select Activity',
            style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: exercices[indexWorkout].activities.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(exercices[indexWorkout].activities[index].title,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    selectedActivity =
                        exercices[indexWorkout].activities[index].title;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveSchedule() async {
    try {
      // Récupération de l'ID utilisateur depuis SharedPreferences
      // String? userId = await SharedpreferenceHelper().getUserId();
      String? userId = await SharedpreferenceHelper().getUserId();

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur: Utilisateur non connecté'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Générer un ID unique pour le planning
      String planningId = DateTime.now().millisecondsSinceEpoch.toString();

      String? activityIconUrl = await ExerciceService.getActivityIconUrl(
          selectedWorkout, selectedActivity);

      print('Activity Icon URL: $activityIconUrl');

      // Créer le modèle planning
      PlanningModel newPlanning = PlanningService.createPlanningModel(
        id: planningId,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        selectedWorkout: selectedWorkout,
        selectedActivity: selectedActivity,
        description: descriptionController.text,
        activityIconUrl: activityIconUrl!,
        userId: userId,
      );

      // Sauvegarder le planning (Firestore + Local)
      bool success = await PlanningService.savePlanning(newPlanning);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout schedule saved successfully!'),
            backgroundColor: Color(0xFF0A1653),
          ),
        );

        // Navigation vers l'écran de confirmation
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2E2F55),
                      Color(0xFF23253C),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: WorkoutSavedScreen(),
              ),
            ),
          );
        });
      } else {
        throw Exception('Erreur lors de la sauvegarde');
      }
    } catch (e) {
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildNumberColumn({
    required int current,
    required int prev,
    required int next,
    bool showAsDoubleDigit = false,
  }) {
    String format(int number) {
      return showAsDoubleDigit
          ? number.toString().padLeft(2, '0')
          : number.toString();
    }

    return Column(
      children: [
        Text(
          format(prev),
          style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        ),
        Text(
          format(current),
          style: TextStyle(
            color: Color(0xFF92A3FD),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          format(next),
          style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildSelectionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF92A3FD).withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
