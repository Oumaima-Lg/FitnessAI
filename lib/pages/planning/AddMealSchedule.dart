import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/return_button.dart';
import 'package:fitness/models/meals.dart';
import 'package:fitness/pages/Alimentation/suivi_repas.dart';
import 'package:fitness/services/MealsPlanning_service.dart';
import 'package:fitness/services/meals_service.dart';
import 'package:flutter/material.dart';

class MealItem {
  final Meal meal;
  double quantity;

  MealItem({
    required this.meal,
    this.quantity = 1.0,
  });

  double get totalCalories => meal.calories * quantity;
  double get totalProteins => (meal.calories * 0.15 / 4) * quantity;
  double get totalCarbs => (meal.calories * 0.55 / 4) * quantity;
  double get totalFats => (meal.calories * 0.30 / 9) * quantity;
}

class AddMealSchedule extends StatefulWidget {
  const AddMealSchedule({super.key});

  @override
  State<AddMealSchedule> createState() => _AddMealScheduleState();
}

class _AddMealScheduleState extends State<AddMealSchedule> {
  late TimeOfDay selectedTime;
  late DateTime selectedDate;
  String selectedMealType = 'Breakfast';
  List<MealItem> addedMeals = [];
  List<Meal> searchResults = [];
  final MealService _mealService = MealService();
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  final List<String> mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack'
  ];

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
    selectedDate = DateTime.now();
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

    int weekdayIndex = date.weekday - 1;
    if (weekdayIndex < 0 || weekdayIndex >= weekdays.length) {
      weekdayIndex = 0;
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

  void _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final meals = await _mealService.searchMeals(query);
      setState(() {
        searchResults = meals;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de recherche: $e')),
      );
    }
  }

  void _addMeal(Meal meal) {
    setState(() {
      addedMeals.add(MealItem(meal: meal));
      searchResults = [];
      _searchController.clear();
    });
  }

  void _removeMeal(int index) {
    setState(() {
      addedMeals.removeAt(index);
    });
  }

  void _updateQuantity(int index, double quantity) {
    setState(() {
      addedMeals[index].quantity = quantity;
    });
  }

  double get totalCalories =>
      addedMeals.fold(0, (sum, item) => sum + item.totalCalories);
  double get totalProteins =>
      addedMeals.fold(0, (sum, item) => sum + item.totalProteins);
  double get totalCarbs =>
      addedMeals.fold(0, (sum, item) => sum + item.totalCarbs);
  double get totalFats =>
      addedMeals.fold(0, (sum, item) => sum + item.totalFats);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildHeader(screenWidth),
                  const SizedBox(height: 40),
                  _buildDateContainer(),
                  const SizedBox(height: 30),
                  _buildTimeContainer(),
                  const SizedBox(height: 30),
                  _buildMealTypeSelector(),
                  const SizedBox(height: 30),
                  _buildMealSearch(),
                  const SizedBox(height: 20),
                  _buildAddedMealsList(),
                  const SizedBox(height: 20),
                  _buildNutritionSummary(),
                  const SizedBox(height: 16),
                  ReturnButton.gradientButton('Save',
                      onPressed: () => _saveSchedule()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(final screenWidth) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReturnButton.returnButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Add Schedule',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.favorite,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildDateContainer() {
    return GestureDetector(
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
    );
  }

  Widget _buildTimeContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildNumberColumn(
                  current:
                      selectedTime.hour % 12 == 0 ? 12 : selectedTime.hour % 12,
                  prev: _getPreviousHour(),
                  next: _getNextHour(),
                ),
                const SizedBox(width: 12),
                const Text(
                  ":",
                  style: TextStyle(
                    color: Color(0xFF92A3FD),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                buildNumberColumn(
                  current: selectedTime.minute,
                  prev: selectedTime.minute == 0 ? 59 : selectedTime.minute - 1,
                  next: selectedTime.minute == 59 ? 0 : selectedTime.minute + 1,
                  showAsDoubleDigit: true,
                ),
                const SizedBox(width: 32),
                Column(
                  children: [
                    Text(
                      selectedTime.period == DayPeriod.am ? "AM" : "PM",
                      style: const TextStyle(
                        color: Color(0xFF92A3FD),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedTime.period == DayPeriod.am ? "PM" : "AM",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meal Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF2A2D4A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF92A3FD).withAlpha(30)),
          ),
          child: DropdownButton<String>(
            value: selectedMealType,
            isExpanded: true,
            underline: SizedBox.shrink(),
            dropdownColor: Color(0xFF2A2D4A),
            style: TextStyle(color: Colors.white, fontSize: 16),
            items: mealTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedMealType = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMealSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search for meals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF2A2D4A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF92A3FD).withAlpha(30)),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ex: salade, chicken, tea...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.search, color: Color(0xFF92A3FD)),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: _searchMeals,
          ),
        ),
        if (isSearching)
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF92A3FD)),
            ),
          ),
        if (searchResults.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 12),
            height: 200,
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final meal = searchResults[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2D4A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        meal.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade700,
                            child: Icon(Icons.restaurant, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      meal.label,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${meal.calories.toInt()} kcal',
                      style: TextStyle(color: Color(0xFF92A3FD), fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add, color: Color(0xFF92A3FD)),
                      onPressed: () => _addMeal(meal),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddedMealsList() {
    if (addedMeals.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFF2A2D4A).withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Colors.grey.shade600, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.restaurant_menu, color: Colors.grey.shade500, size: 48),
            SizedBox(height: 12),
            Text(
              'There are no meals added yet',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
            Text(
              'Research and add meals to your schedule',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals added (${addedMeals.length})',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...addedMeals.asMap().entries.map((entry) {
          int index = entry.key;
          MealItem mealItem = entry.value;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF2A2D4A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF92A3FD).withAlpha(30)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        mealItem.meal.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade700,
                            child: Icon(Icons.restaurant, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealItem.meal.label,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${mealItem.totalCalories.toInt()} kcal',
                            style: TextStyle(
                                color: Color(0xFF92A3FD), fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade400),
                      onPressed: () => _removeMeal(index),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Quantité: ',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Expanded(
                      child: Slider(
                        value: mealItem.quantity,
                        min: 0.25,
                        max: 3.0,
                        divisions: 11,
                        activeColor: Color(0xFF92A3FD),
                        inactiveColor: Colors.grey.shade600,
                        onChanged: (value) => _updateQuantity(index, value),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF92A3FD).withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${mealItem.quantity.toStringAsFixed(2)}x',
                        style: TextStyle(
                            color: Color(0xFF92A3FD),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNutritionSummary() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF92A3FD).withAlpha(20),
            Color(0xFF9DCEFF).withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF92A3FD).withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFF92A3FD), size: 24),
              SizedBox(width: 8),
              Text(
                'Nutrtion Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF2A2D4A).withAlpha(70),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department,
                    color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Text(
                  '${totalCalories.toInt()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' kcal',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMacroCard(
                  'Proteines',
                  '${totalProteins.toInt()}g',
                  Color(0xFF92A3FD),
                  Icons.fitness_center,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  'Carbs',
                  '${totalCarbs.toInt()}g',
                  Color(0xFF9DCEFF),
                  Icons.grain,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard(
                  'Fats',
                  '${totalFats.toInt()}g',
                  Color(0xFFFFA726),
                  Icons.opacity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getPreviousHour() {
    int currentHour = selectedTime.hour % 12;
    if (currentHour == 0) currentHour = 12;
    return currentHour == 1 ? 12 : currentHour - 1;
  }

  int _getNextHour() {
    int currentHour = selectedTime.hour % 12;
    if (currentHour == 0) currentHour = 12;
    return currentHour == 12 ? 1 : currentHour + 1;
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          format(prev),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          width: 40,
          height: 1,
          color: Colors.grey.shade700,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            format(current),
            style: const TextStyle(
              color: Color(0xFF92A3FD),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 1,
          color: Colors.grey.shade700,
        ),
        Text(
          format(next),
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _saveSchedule() async {
    final mealPlanningService = MealPlanningService();
    try {
      await mealPlanningService.addPlannedMeal(
        date: selectedDate,
        time: selectedTime,
        mealType: selectedMealType,
        items: addedMeals,
        totalCalories: totalCalories,
        totalProteins: totalProteins,
        totalCarbs: totalCarbs,
        totalFats: totalFats,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to your meal plan!'),
          backgroundColor: Color(0xFF0A1653),
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => SuivisRepasScreen(),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
