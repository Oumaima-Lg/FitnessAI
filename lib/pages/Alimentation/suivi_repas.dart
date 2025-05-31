import 'package:fitness/components/return_button.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/alimentation/meal_element.dart';
import 'package:flutter/material.dart';
import 'package:fitness/services/MealsPlanning_service.dart';

class SuivisRepasScreen extends StatefulWidget {
  const SuivisRepasScreen({super.key});

  @override
  State<SuivisRepasScreen> createState() => _SuivisRepasScreenState();
}

class _SuivisRepasScreenState extends State<SuivisRepasScreen> {
  Set<int> clickedIndexes = {};
  final List<Meal> mealsList = meals;

  final MealPlanningService _mealService = MealPlanningService();
  List<Map<String, dynamic>> plannedMeals = [];
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPlannedMeals();
  }

  Future<void> _loadPlannedMeals() async {
    final meals = await _mealService.getPlannedMealsForDate(currentDate);
    setState(() {
      plannedMeals = meals;
    });
  }

  Map<String, List<Map<String, dynamic>>> get groupedMeals {
    final Map<String, List<Map<String, dynamic>>> groups = {
      'Breakfast': [],
      'Lunch': [],
      'Dinner': [],
      'Snack': [],
    };

    for (var meal in plannedMeals) {
      final type = meal['mealType'];
      if (groups.containsKey(type)) {
        groups[type]!.add(meal);
      }
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final List<String> mealsType = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.height * 0.05,
          vertical: screenSize.width * 0.02,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E2F55), Color(0xFF23253C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: mealsType.length,
                  itemBuilder: (context, index) => _mealSection(
                    mealsType[index],
                    index,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _summaryContainer(screenSize.width),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar personnalisé
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Today\'s Meals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildScannerButton(),
        ],
      ),
    );
  }

  // Bouton scanner
  Widget _buildScannerButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFC58BF2), Color(0xFFEEA4CE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(92, 238, 164, 206),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(4, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.center_focus_weak, color: Colors.white),
        onPressed: () => print('Scanner'),
      ),
    );
  }

  // Section de repas (bouton + historique)
  Widget _mealSection(String label, int index) {
    final mealsForType = groupedMeals[label] ?? [];
    final isExpanded = clickedIndexes.contains(index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _toggleSection(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E2F55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              side: BorderSide(
                color: const Color(0xFFE8ACFF).withAlpha(51),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    label,
                    style: normalTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_more : Icons.expand_less,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (isExpanded) _mealHistory(mealsForType),
        ],
      ),
    );
  }

  // Historique des repas
  Widget _mealHistory(List<Map<String, dynamic>> meals) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFFFFF).withAlpha(70),
              const Color(0xFF999999).withAlpha(60),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 365,
            child: meals.isEmpty
                ? Center(
                    child: Text(
                      'No meals planned for this time.',
                      style: normalTextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _timelineIndicator(),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${meal['time']} - ${meal['mealType']}",
                                  style: titleTextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  children: meal['items'].map<Widget>((item) {
                                    return _mealElement(
                                      name: item['label'],
                                      weight: "${item['quantity']} portion(s)",
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            // child: ListView.builder(
            //   itemCount: mealsList.length,
            //   itemBuilder: (context, index) {
            //     final meal = mealsList[index];
            //     return Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         _timelineIndicator(),
            //         const SizedBox(width: 10),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 meal.mealName,
            //                 style: titleTextStyle(
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 18,
            //                 ),
            //               ),
            //               const SizedBox(height: 5),
            //               Wrap(
            //                 children: meal.mealElements.map((element) {
            //                   return _mealElement(
            //                     name: element.name,
            //                     weight: element.weigth,
            //                   );
            //                 }).toList(),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            // ),
          ),
        ),
      ),
    );
  }

  // Indicateur de timeline
  Widget _timelineIndicator() {
    return Column(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFC58BF2),
          ),
          child: Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFC58BF2),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(15, (i) {
            return Container(
              width: 2,
              height: 5,
              color: i % 2 == 0 ? const Color(0xFFC58BF2) : Colors.transparent,
            );
          }),
        ),
      ],
    );
  }

  // Élément de repas
  Widget _mealElement({required String name, required String weight}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF4E457B).withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8ACFF).withAlpha(51),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: normalTextStyle(color: const Color(0xC4E8ACFF)),
          ),
          Text(
            weight,
            style: normalTextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Résumé quotidien
  Widget _summaryContainer(double screenWidth) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 137,
        minWidth: screenWidth * 0.8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9DCEFF).withAlpha(80),
            const Color(0xFF92A3FD).withAlpha(70)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daily Summary', style: normalTextStyle()),
                const SizedBox(height: 12),
                ReturnButton.gradientButton(
                  'Details',
                  onPressed: () => print('Details'),
                ),
              ],
            ),
            Image.asset(
              'images/summary.png',
              height: 82,
              width: 121,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSection(int index) {
    setState(() {
      clickedIndexes.contains(index)
          ? clickedIndexes.remove(index)
          : clickedIndexes.add(index);
    });
  }
}
