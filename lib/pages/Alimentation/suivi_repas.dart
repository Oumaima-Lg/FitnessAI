import 'package:fitness/components/return_button.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/alimentation/meal_element.dart';
import 'package:flutter/material.dart';

class SuiviRepas extends StatefulWidget {
  const SuiviRepas({super.key});

  @override
  State<SuiviRepas> createState() => _SuiviRepasState();
}

class _SuiviRepasState extends State<SuiviRepas> {
  Set<int> clickedIndexes = {};
  final List<Meal> mealsList = meals;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final List<String> mealsType = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.05, vertical: screenWidth * 0.02),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E2F55), Color(0xFF23253C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              alimentationAppBar(
                context: context,
                title: 'Today\'s Meals',
                rightWidget: appBarIcon(iconAppBar: Icons.center_focus_weak),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: mealsType.length,
                  itemBuilder: (context, index) {
                    final isClicked = clickedIndexes.contains(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: customMealButton(
                        label: mealsType[index],
                        isClicked: isClicked,
                        onTap: () {
                          setState(() {
                            if (isClicked) {
                              clickedIndexes.remove(index);
                            } else {
                              clickedIndexes.add(index);
                            }
                          });
                        },
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 10),
              summaryContainer(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Container summaryContainer(double screenWidth) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 137,
        minWidth: screenWidth * 0.8,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF9DCEFF).withAlpha(80),
            Color(0xFF92A3FD).withAlpha(70)
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
                Text(
                  'Daily Summary',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 12),
                ReturnButton.gradientButton(
                  'Details',
                  onPressed: () {
                    print('Details');
                  },
                ),
              ],
            ),
            Image(
              image: AssetImage('images/summary.png'),
              height: 82,
              width: 121,
            ),
          ],
        ),
      ),
    );
  }

  Widget customMealButton({
    required String label,
    required bool isClicked,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: onTap,
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
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Icon(
                  isClicked
                      ? Icons.expand_more
                      : Icons.expand_less,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        if (isClicked)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: mealsHistorique(),
          ),
      ],
    );
  }

  Widget alimentationAppBar({
    required BuildContext context,
    required String title,
    Widget? rightWidget,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: rightWidget ?? const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget appBarIcon({required IconData iconAppBar}) {
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
        iconSize: 30,
        icon: Icon(
          iconAppBar,
          color: Colors.white,
        ),
        onPressed: () {
          print('Scanner');
        },
      ),
    );
  }
  Container mealsHistorique() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF).withAlpha(70),
            Color(0xFF999999).withAlpha(60),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 365, 
          child: ListView.builder(
            itemCount: mealsList.length,
            itemBuilder: (context, index) {
              final meal = mealsList[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  stepElement(),
                  SizedBox(width: 10), 
                  Expanded( 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.mealName,
                          style: titleTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: meal.mealElements.map((element) {
                            return mealElement(
                              name: element.name,
                              weight: element.weigth,
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
        ),
      ),
    );
  }

  Column stepElement() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFC58BF2),
              ),
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFC58BF2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: List.generate(15, (i) {
            return Container(
              width: 2,
              height: 5,
              color: i % 2 == 0
                ? Color(0xFFC58BF2)
                : Colors.transparent,
            );
          }),
        ),
      ],
    );
  }

  Widget mealElement({required String name, required String weight}) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF4E457B).withAlpha(15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE8ACFF).withAlpha(51),
            width: 2,
          )
        ),
        child: Column(
          children: [
            Text(
              name,
              style: normalTextStyle(
                color: Color(0xC4E8ACFF),
              ),
            ),
            Text(
              weight,
              style: normalTextStyle(
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}