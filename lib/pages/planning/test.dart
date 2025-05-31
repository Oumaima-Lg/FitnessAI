import 'package:fitness/services/shared_pref.dart';
import 'package:fitness/models/User.dart';
import 'package:fitness/services/database.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Getters pour accès rapide aux propriétés utilisateur
  String? get userId => _currentUser?.id;
  String? get userName => _currentUser?.name;
  String? get userEmail => _currentUser?.email;
  String? get userImageUrl => _currentUser?.imageUrl;
  int? get userAge => _currentUser?.age;
  String? get userPhone => _currentUser?.phone;
  double? get userWeight => _currentUser?.weight;
  double? get userHeight => _currentUser?.height;
  String? get userAddress => _currentUser?.address;

  Future<void> initializeUser() async {
    try {
      final sharedPref = SharedpreferenceHelper();
      
      final String? id = await sharedPref.getUserId();
      final String? name = await sharedPref.getUserName();
      final String? email = await sharedPref.getUserEmail();
      final String? imageUrl = await sharedPref.getUserImageURL();
      final int? age = await sharedPref.getUserAge();
      final String? phone = await sharedPref.getUserPhone();
      final double? weight = await sharedPref.getUserWeight();
      final double? height = await sharedPref.getUserHeight();
      final String? address = await sharedPref.getUserAddress();

      if (id != null && name != null && email != null) {
        _currentUser = UserModel(
          id: id,
          name: name,
          email: email,
          imageUrl: imageUrl,
          age: age,
          phone: phone,
          weight: weight,
          height: height,
          address: address,
        );
      }
    } catch (e) {
      print('Erreur lors de l\'initialisation de l\'utilisateur: $e');
    }
  }

  Future<void> loginUser(UserModel user) async {
    try {
      final sharedPref = SharedpreferenceHelper();
      
      await sharedPref.saveUserId(user.id);
      await sharedPref.saveUserName(user.name);
      await sharedPref.saveUserEmail(user.email);
      
      if (user.imageUrl != null) {
        await sharedPref.saveUserImageURL(user.imageUrl!);
      }
      
      if (user.age != null) {
        await sharedPref.saveUserAge(user.age!);
      }
      
      if (user.phone != null) {
        await sharedPref.saveUserPhone(user.phone!);
      }
      
      if (user.weight != null) {
        await sharedPref.saveUserWeight(user.weight!);
      }
      
      if (user.height != null) {
        await sharedPref.saveUserHeight(user.height!);
      }
      
      if (user.address != null) {
        await sharedPref.saveUserAddress(user.address!);
      }

      _currentUser = user;
      
    } catch (e) {
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  Future<void> registerUser(UserModel user) async {
    try {
      await DatabaseMethods().addUserDetails(user.toMap(), user.id);
      await loginUser(user);
      
    } catch (e) {
      throw Exception('Erreur lors de l\'enregistrement: $e');
    }
  }

  // Mettre à jour les informations utilisateur
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      // Mettre à jour dans Firestore
      await DatabaseMethods().addUserDetails(updatedUser.toMap(), updatedUser.id);
      
      // Mettre à jour dans SharedPreferences
      await loginUser(updatedUser);
      
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: $e');
    }
  }

  // Méthodes spécifiques pour mettre à jour des champs individuels
  // Future<void> updateUserProfile({
  //   String? name,
  //   String? email,
  //   String? imageUrl,
  //   int? age,
  //   String? phone,
  //   double? weight,
  //   double? height,
  //   String? address,
  // }) async {
  //   if (_currentUser == null) {
  //     throw Exception('Aucun utilisateur connecté');
  //   }

  //   try {
  //     final updatedUser = _currentUser!.copyWith(
  //       name: name,
  //       email: email,
  //       imageUrl: imageUrl,
  //       age: age,
  //       phone: phone,
  //       weight: weight,
  //       height: height,
  //       address: address,
  //     );

  //     await updateUser(updatedUser);
  //   } catch (e) {
  //     throw Exception('Erreur lors de la mise à jour du profil: $e');
  //   }
  // }

  // Mettre à jour seulement les informations physiques
  // Future<void> updatePhysicalInfo({
  //   int? age,
  //   double? weight,
  //   double? height,
  // }) async {
  //   await updateUserProfile(
  //     age: age,
  //     weight: weight,
  //     height: height,
  //   );
  // }

  // // Mettre à jour les informations de contact
  // Future<void> updateContactInfo({
  //   String? phone,
  //   String? address,
  // }) async {
  //   await updateUserProfile(
  //     phone: phone,
  //     address: address,
  //   );
  // }

  // // Mettre à jour l'image de profil
  // Future<void> updateProfileImage(String imageUrl) async {
  //   await updateUserProfile(imageUrl: imageUrl);
  // }

  // Déconnexion
  Future<void> logoutUser() async {
    try {
      final sharedPref = SharedpreferenceHelper();
      await sharedPref.clearUserData();
      _currentUser = null;
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  // Rafraîchir les données utilisateur depuis Firestore
  Future<void> refreshUserData() async {
    if (_currentUser == null) return;
    
    try {
      // Récupérer les données depuis Firestore
      final userData = await DatabaseMethods().getUserDetails(_currentUser!.id);
      
      if (userData != null) {
        final updatedUser = UserModel.fromMap(userData);
        await loginUser(updatedUser);
      }
    } catch (e) {
      print('Erreur lors du rafraîchissement des données: $e');
    }
  }

  // Ajouter un workout au planning de l'utilisateur
  Future<void> addWorkoutToPlanning(Map<String, dynamic> workoutData) async {
    if (_currentUser == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    try {
      // Ajouter l'ID utilisateur aux données
      workoutData['userId'] = _currentUser!.id;
      
      await DatabaseMethods().addUserWorkoutDetails(workoutData, _currentUser!.id);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du workout: $e');
    }
  }
  // Méthode pour obtenir les préférences de l'utilisateur
  gettheshredpref() async {
    await initializeUser();
  }

  // Validation des données utilisateur
  bool isProfileComplete() {
    if (_currentUser == null) return false;
    
    return _currentUser!.name.isNotEmpty &&
           _currentUser!.email.isNotEmpty &&
           _currentUser!.age != null &&
           _currentUser!.weight != null &&
           _currentUser!.height != null;
  }

  // // Obtenir le pourcentage de completion du profil
  // double getProfileCompletionPercentage() {
  //   if (_currentUser == null) return 0.0;
    
  //   int completedFields = 0;
  //   int totalFields = 8; // id, name, email, imageUrl, age, phone, weight, height, address
    
  //   if (_currentUser!.id.isNotEmpty) completedFields++;
  //   if (_currentUser!.name.isNotEmpty) completedFields++;
  //   if (_currentUser!.email.isNotEmpty) completedFields++;
  //   if (_currentUser!.imageUrl != null && _currentUser!.imageUrl!.isNotEmpty) completedFields++;
  //   if (_currentUser!.age != null) completedFields++;
  //   if (_currentUser!.phone != null && _currentUser!.phone!.isNotEmpty) completedFields++;
  //   if (_currentUser!.weight != null) completedFields++;
  //   if (_currentUser!.height != null) completedFields++;
  //   if (_currentUser!.address != null && _currentUser!.address!.isNotEmpty) completedFields++;
    
  //   return (completedFields / totalFields) * 100;
  // }
}





