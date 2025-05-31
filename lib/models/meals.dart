class Meal {
  final String label;
  final String imageUrl;
  final double calories;
  final double rating;
  final List<String> dietLabels;
  final List<String> healthLabels;
  final List<String> ingredients;
  final String mealType;

  final List<Meal> mealElements;

  Meal({
    required this.label,
    required this.imageUrl,
    required this.calories,
    required this.rating,
    required this.dietLabels,
    required this.healthLabels,
    required this.ingredients,
    required this.mealType,
    this.mealElements = const [],
  });


  factory Meal.fromEdamamJson(Map<String, dynamic> json) {
    final recipe = json['recipe'];
    

    String label = recipe['label'] ?? 'Unknown Meal';
    String imageUrl = recipe['image'] ?? 'https://via.placeholder.com/120';
    double calories = recipe['calories'] != null ? (recipe['calories'] as num).toDouble() : 0.0;
    
    
    List<String> dietLabels = recipe['dietLabels'] != null
        ? List<String>.from(recipe['dietLabels'])
        : [];
    
    List<String> healthLabels = recipe['healthLabels'] != null
        ? List<String>.from(recipe['healthLabels'])
        : [];
    
    
    List<String> ingredients = [];
    if (recipe['ingredients'] != null) {
      for (var ingredient in recipe['ingredients']) {
        if (ingredient['text'] != null) {
          ingredients.add(ingredient['text']);
        }
      }
    }
    
    
    List<String> mealTypes = recipe['mealType'] != null
        ? List<String>.from(recipe['mealType'])
        : [];
    String mealType = mealTypes.isNotEmpty ? mealTypes.first : 'Meal';
    
    
    double rating = 4.5;
    
    return Meal(
      label: label,
      imageUrl: imageUrl,
      calories: calories,
      rating: rating,
      dietLabels: dietLabels,
      healthLabels: healthLabels,
      ingredients: ingredients,
      mealType: mealType,
    );
  }
}