import 'dart:io';

import 'package:fitness/pages/Alimentation/meal_details.dart';
import 'package:flutter/material.dart';
import 'package:fitness/services/meals_service.dart';
import 'package:fitness/models/meals.dart';
import 'package:fitness/pages/profil/ImagePicker.dart';
import 'package:image_picker/image_picker.dart';

class AlimHomePage extends StatefulWidget {
  const AlimHomePage({super.key});

  @override
  State<AlimHomePage> createState() => _AlimHomePageState();
}

class _AlimHomePageState extends State<AlimHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Hottest", "Popular", "New combo", "Top"];

  final MealService _mealManager = MealService();

  List<Meal> _recommendedMeals = [];
  List<Meal> _categoryMeals = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);

    _loadInitialData();
  }

  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recommendedMeals = await _mealManager.getCombinedRecommendedMeals();
      final categoryMeals = await _mealManager.getMealsByCategory(_tabs[0]);

      if (mounted) {
        setState(() {
          _recommendedMeals = recommendedMeals;
          _categoryMeals = categoryMeals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erreur lors du chargement des données: $e');
      }
    }
  }

  void _handleTabChange() async {
    if (_tabController.indexIsChanging ||
        _tabController.index != _tabController.previousIndex) {
      await _loadMealsByCategory(_tabs[_tabController.index]);
    }
  }

  Future<void> _loadMealsByCategory(String category) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final meals = await _mealManager.getMealsByCategory(category);

      if (mounted) {
        setState(() {
          _categoryMeals = meals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erreur lors du chargement des repas: $e');
      }
    }
  }

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      await _loadMealsByCategory(_tabs[_tabController.index]);
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      final meals = await _mealManager.searchMeals(query);

      if (mounted) {
        setState(() {
          _categoryMeals = meals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Erreur lors de la recherche: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(screenWidth),
                  const SizedBox(height: 40),
                  _buildSearchBar(),
                  const SizedBox(height: 30),
                  _buildRecommendedMealsSection(screenWidth),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(),
                  const SizedBox(height: 16),
                  _isLoading
                      ? _buildLoadingIndicator()
                      : _buildMealGridWithFixedHeight(
                          screenHeight, screenWidth),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 12),
        child: _buildDetailsButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE95CC0)),
        ),
      ),
    );
  }

  Widget _buildHeader(final screenWidth) {
    return Center(
      child: Text(
        "Healthy Bites",
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showInfoPopup(BuildContext context) {
    File? _image;

    final _formKey = GlobalKey<FormState>();
    String mealName = '';
    String mealCategory = 'Breakfast';
    String imageUrl = '';
    String calories = '';
    String ingrediant = '';
    double rating = 4.0;

    List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 339,
                    height: 550,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2E2F55),
                          Color(0xFF23253C),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xFFEEA4CE),
                        width: 0.3,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: 80,
                      left: 30,
                      right: 30,
                      bottom: 30,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),

                            // Nom du repas
                            Text(
                              'Meal Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter meal name',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Color(0xFF4E457B).withAlpha(50),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE95CC0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a meal name';
                                }
                                return null;
                              },
                              onChanged: (value) => mealName = value,
                            ),

                            SizedBox(height: 16),

                            // Catégorie
                            Text(
                              'Category',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFF4E457B).withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: mealCategory,
                                  isExpanded: true,
                                  dropdownColor: Color(0xFF2E2F55),
                                  style: TextStyle(color: Colors.white),
                                  items: mealTypes.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setDialogState(() {
                                      mealCategory = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            // URL de l'image
                            Text(
                              'Meal Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFF4E457B).withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: _image == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image,
                                            color: Colors.grey, size: 40),
                                        SizedBox(height: 8),
                                        Text(
                                          'No image selected',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 120,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      try {
                                        final XFile? photo =
                                            await picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 80,
                                          maxWidth: 800,
                                        );
                                        if (photo != null) {
                                          setDialogState(() {
                                            _image = File(photo.path);
                                            imageUrl = photo
                                                .path; // Pour la compatibilité
                                          });
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Error taking photo: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.camera_alt, size: 16),
                                    label: Text('Camera'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF4E457B),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      try {
                                        final XFile? image =
                                            await picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 80,
                                          maxWidth: 800,
                                        );
                                        if (image != null) {
                                          setDialogState(() {
                                            _image = File(image.path);
                                            imageUrl = image
                                                .path; // Pour la compatibilité
                                          });
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Error selecting image: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.photo_library, size: 16),
                                    label: Text('Gallery'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF4E457B),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            // Calories
                            Text(
                              'Calories',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter calories',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Color(0xFF4E457B).withAlpha(50),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE95CC0)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter calories';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              onChanged: (value) => calories = value,
                            ),

                            SizedBox(height: 16),

                            // Description
                            Text(
                              'Ingrediants',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter Ingrediants',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Color(0xFF4E457B).withAlpha(50),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE95CC0)),
                                ),
                              ),
                              onChanged: (value) => ingrediant = value,
                            ),

                            SizedBox(height: 16),

                            // Rating
                            Text(
                              'Rating: ${rating.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Slider(
                              value: rating,
                              min: 1.0,
                              max: 5.0,
                              divisions: 8,
                              activeColor: Color(0xFFE95CC0),
                              inactiveColor: Colors.grey,
                              onChanged: (value) {
                                setDialogState(() {
                                  rating = value;
                                });
                              },
                            ),

                            SizedBox(height: 24),

                            // Bouton Save
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _saveMeal(
                                      mealName,
                                      mealCategory,
                                      imageUrl,
                                      calories,
                                      ingrediant,
                                      rating,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 187, 130, 231),
                                        Color.fromARGB(255, 224, 143, 189),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Save Meal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Header avec titre et bouton fermer
                  Positioned(
                    top: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 60),
                        Text(
                          'Add new meal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Méthode pour sauvegarder le repas
  Future<void> _saveMeal(
    String name,
    String category,
    String imageUrl,
    String calories,
    String description,
    double rating,
  ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE95CC0)),
          ),
        ),
      );

      final newMeal = Meal(
        label: name,
        imageUrl:
            imageUrl.isEmpty ? 'https://via.placeholder.com/120' : imageUrl,
        calories: double.tryParse(calories) ?? 0.0,
        rating: rating,
        dietLabels: [],
        healthLabels: [],
        ingredients: description.isNotEmpty ? [description] : [],
        mealType: category,
      );

      final mealId = await _mealManager.saveCustomMealToFirebase(newMeal);
      Navigator.pop(context);

      if (mealId != null) {
        setState(() {
          _recommendedMeals.add(newMeal);
          if (_tabs[_tabController.index].toLowerCase() ==
                  category.toLowerCase() ||
              _tabs[_tabController.index] == "Hottest") {
            _categoryMeals.add(newMeal);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Meal added successfully!'),
            backgroundColor: Color(0xFFE95CC0),
            duration: Duration(seconds: 2),
          ),
        );
      }

      _loadInitialData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding meal: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF4E457B).withAlpha(50),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFFFFFF),
          width: 0.3,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(color: Color.fromARGB(255, 221, 221, 221)),
              decoration: InputDecoration(
                hintText: "Search for new food...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onSubmitted: (value) {
                _searchMeals(value);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.arrow_forward,
                color: Colors.grey,
                size: 24,
              ),
              onPressed: () {
                if (_isSearching) {
                  setState(() {
                    _isSearching = false;
                    _searchQuery = '';
                  });
                  _loadMealsByCategory(_tabs[_tabController.index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedMealsSection(final screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommended meals",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: _isLoading
              ? _buildLoadingIndicator()
              : _recommendedMeals.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun repas recommandé disponible",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recommendedMeals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildMealCard(_recommendedMeals[index]),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildMealCard([Meal? meal]) {
    final String mealName = meal?.label ?? "Olive Salad";
    final String imageUrl = meal?.imageUrl ?? 'https://via.placeholder.com/120';
    final String calories =
        meal != null ? "${meal.calories.toInt() ~/ 100} Kcal" : "17 Kcal";
    final double rating = meal?.rating ?? 4.5;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            width: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFCAD4DB).withAlpha(97),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 40, 12, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    style: TextStyle(
                      color: Color.fromARGB(255, 15, 15, 26),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: _buildRatingStars(rating),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        calories,
                        style: TextStyle(
                          color: Color.fromARGB(255, 15, 15, 26),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        width: 45,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      mealDetailsPage(meal: meal!),
                                ),
                              );
                            },
                            child: Text(
                              "Details",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 98,
          height: 91,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 98,
                  height: 91,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: 12));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: 12));
    }

    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: 12));
    }

    return stars;
  }

  Widget _buildCategoryTabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: Color(0xFFCE90EA),
      unselectedLabelColor: Colors.grey,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE95CC0),
            width: 2,
          ),
        ),
      ),
      tabs: _tabs.map((String name) => Tab(text: name)).toList(),
    );
  }

  Widget _buildMealGridWithFixedHeight(
      double screenHeight, double screenWidth) {
    final gridHeight = screenHeight * 0.9;

    return SizedBox(
      height: gridHeight,
      width: screenWidth * 0.9,
      child: _categoryMeals.isEmpty
          ? Center(
              child: Text(
                _isSearching
                    ? "Aucun résultat trouvé pour '$_searchQuery'"
                    : "Aucun repas disponible dans cette catégorie",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 1 : 2,
                childAspectRatio: screenWidth / (screenHeight / 1.5),
                crossAxisSpacing: 9,
                mainAxisSpacing: 20,
              ),
              itemCount: _categoryMeals.length,
              itemBuilder: (context, index) {
                return _buildMealCard(_categoryMeals[index]);
              },
            ),
    );
  }

  Widget _buildDetailsButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 187, 130, 231),
            Color.fromARGB(255, 224, 143, 189)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: IconButton(
        iconSize: 20,
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          _showInfoPopup(context);
        },
      ),
    );
  }
}
