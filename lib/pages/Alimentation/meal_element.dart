class MealElement {
  final String name;
  final String weigth;

  MealElement({
    required this.name,
    required this.weigth,
  });
}


class Meal{
  final String mealName;
  final List<MealElement> mealElements;

  Meal({
    required this.mealName,
    required this.mealElements,
  });
}

List<Meal> meals = [
  Meal(
    mealName: 'Meal 1',
    mealElements: [
      MealElement(name: 'Fiber', weigth: '5g'),
      MealElement(name: 'Protein', weigth: '3g'),
      MealElement(name: 'Lipids', weigth: '2g'),
      MealElement(name: 'Fat', weigth: '32g'),
    ]
  ),
  Meal(
    mealName: 'Meal 2', 
    mealElements: [
      MealElement(name: 'Fiber', weigth: '5g'),
      MealElement(name: 'Protein', weigth: '3g'),
      MealElement(name: 'Lipids', weigth: '2g'),
      MealElement(name: 'Fat', weigth: '32g'),
    ]
  ),
  Meal(
    mealName: 'Meal 1', 
    mealElements: [
      MealElement(name: 'Fiber', weigth: '5g'),
      MealElement(name: 'Protein', weigth: '3g'),
      MealElement(name: 'Lipids', weigth: '2g'),
      MealElement(name: 'Fat', weigth: '32g'),
    ]
  ),
];