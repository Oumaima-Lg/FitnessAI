// import 'package:fitness/services/shared_pref.dart';
// import 'package:fitness/models/User.dart';
// import 'package:fitness/services/database.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserService {
//   static final UserService _instance = UserService._internal();
//   factory UserService() => _instance;
//   UserService._internal();

//   UserModel? _currentUser;

//   UserModel? get currentUser => _currentUser;
//   bool get isLoggedIn => _currentUser != null;

//   String? get userId => _currentUser?.id;
//   String? get userName => _currentUser?.name;
//   String? get userEmail => _currentUser?.email;
//   String? get userImageUrl => _currentUser?.imageUrl;
//   int? get userAge => _currentUser?.age;
//   String? get userPhone => _currentUser?.phone;
//   double? get userWeight => _currentUser?.weight;
//   double? get userHeight => _currentUser?.height;
//   String? get userAddress => _currentUser?.address;


//   Future<bool> initializeUser() async {
//     try {
//       bool loadedFromPrefs = await _loadFromSharedPreferences();
      
//       if (loadedFromPrefs) {
//         await _syncWithFirestore();
//         return true;
//       } else {
//         return await _loadFromFirebaseAuth();
//       }
//     } catch (e) {
//       print('Erreur lors de l\'initialisation de l\'utilisateur: $e');
//       return false;
//     }
//   }

//   Future<bool> _loadFromSharedPreferences() async {
//     try {
//       final sharedPref = SharedpreferenceHelper();
      
//       final String? id = await sharedPref.getUserId();
//       final String? name = await sharedPref.getUserName();
//       final String? email = await sharedPref.getUserEmail();
//       final String? imageUrl = await sharedPref.getUserImageURL();
//       final int? age = await sharedPref.getUserAge();
//       final String? phone = await sharedPref.getUserPhone();
//       final double? weight = await sharedPref.getUserWeight();
//       final double? height = await sharedPref.getUserHeight();
//       final String? address = await sharedPref.getUserAddress();

//       if (id != null && name != null && email != null) {
//         _currentUser = UserModel(
//           id: id,
//           name: name,
//           email: email,
//           imageUrl: imageUrl,
//           age: age,
//           phone: phone,
//           weight: weight,
//           height: height,
//           address: address,
//         );
//         print('Utilisateur chargé depuis SharedPreferences: ${_currentUser!.name}');
//         return true;
//       }
      
//       return false;
//     } catch (e) {
//       print('Erreur lors du chargement depuis SharedPreferences: $e');
//       return false;
//     }
//   }


//   Future<bool> _loadFromFirebaseAuth() async {
//     try {
//       final User? firebaseUser = FirebaseAuth.instance.currentUser;
      
//       if (firebaseUser != null) {
//         print('Utilisateur Firebase trouvé: ${firebaseUser.uid}');
        
        
//         final userData = await DatabaseMethods().getUserDetails(firebaseUser.uid);
        
//         if (userData != null) {
//           final UserModel user = UserModel.fromMap(userData);
//           await loginUser(user);
//           print('Utilisateur chargé depuis Firestore: ${user.name}');
//           return true;
//         } else {
//           print('Données utilisateur non trouvées dans Firestore pour l\'UID: ${firebaseUser.uid}');
//         }
//       }
      
//       return false;
//     } catch (e) {
//       print('Erreur lors du chargement depuis Firebase Auth: $e');
//       return false;
//     }
//   }

//   // Synchroniser avec Firestore pour récupérer les dernières données
//   Future<void> _syncWithFirestore() async {
//     if (_currentUser == null) return;
    
//     try {
//       final userData = await DatabaseMethods().getUserDetails(_currentUser!.id);
      
//       if (userData != null) {
//         final UserModel updatedUser = UserModel.fromMap(userData);
        
//         if (_hasUserDataChanged(updatedUser)) {
//           await _updateSharedPreferences(updatedUser);
//           _currentUser = updatedUser;
//           print('Données utilisateur synchronisées depuis Firestore');
//         }
//       }
//     } catch (e) {
//       print('Erreur lors de la synchronisation avec Firestore: $e');
//     }
//   }

//   // Vérifier si les données ont changé
//   bool _hasUserDataChanged(UserModel newUser) {
//     if (_currentUser == null) return true;
    
//     return _currentUser!.name != newUser.name ||
//            _currentUser!.email != newUser.email ||
//            _currentUser!.imageUrl != newUser.imageUrl ||
//            _currentUser!.age != newUser.age ||
//            _currentUser!.phone != newUser.phone ||
//            _currentUser!.weight != newUser.weight ||
//            _currentUser!.height != newUser.height ||
//            _currentUser!.address != newUser.address;
//   }


//   Future<void> _updateSharedPreferences(UserModel user) async {
//     final sharedPref = SharedpreferenceHelper();
    
//     await sharedPref.saveUserId(user.id);
//     await sharedPref.saveUserName(user.name);
//     await sharedPref.saveUserEmail(user.email);
    
//     if (user.imageUrl != null) {
//       await sharedPref.saveUserImageURL(user.imageUrl!);
//     }
    
//     if (user.age != null) {
//       await sharedPref.saveUserAge(user.age!);
//     }
    
//     if (user.phone != null) {
//       await sharedPref.saveUserPhone(user.phone!);
//     }
    
//     if (user.weight != null) {
//       await sharedPref.saveUserWeight(user.weight!);
//     }
    
//     if (user.height != null) {
//       await sharedPref.saveUserHeight(user.height!);
//     }
    
//     if (user.address != null) {
//       await sharedPref.saveUserAddress(user.address!);
//     }
//   }

//   // Connexion utilisateur
//   Future<void> loginUser(UserModel user) async {
//     try {
//       await _updateSharedPreferences(user);
//       _currentUser = user;
//       print('Utilisateur connecté: ${user.name}');
//     } catch (e) {
//       throw Exception('Erreur lors de la connexion: $e');
//     }
//   }

//   // Enregistrement utilisateur
//   // Future<void> registerUser(UserModel user) async {
//   //   try {
//   //     await DatabaseMethods().addUserDetails(user.toMap(), user.id);
//   //     await loginUser(user);
//   //     print('Utilisateur enregistré: ${user.name}');
//   //   } catch (e) {
//   //     throw Exception('Erreur lors de l\'enregistrement: $e');
//   //   }
//   // }

//   // Mettre à jour les informations utilisateur
//   Future<void> updateUser(UserModel updatedUser) async {
//     try {
//       await DatabaseMethods().addUserDetails(updatedUser.toMap(), updatedUser.id);
      
//       // await loginUser(updatedUser);
      
//       print('Utilisateur mis à jour: ${updatedUser.name}');
//     } catch (e) {
//       throw Exception('Erreur lors de la mise à jour: $e');
//     }
//   }

//   // Déconnexion
//   Future<void> logoutUser() async {
//     try {
//       final sharedPref = SharedpreferenceHelper();
//       await sharedPref.clearUserData();
//       _currentUser = null;
//       print('Utilisateur déconnecté');
//     } catch (e) {
//       throw Exception('Erreur lors de la déconnexion: $e');
//     }
//   }

//   // Rafraîchir les données utilisateur depuis Firestore
//   Future<void> refreshUserData() async {
//     if (_currentUser == null) {
//       // Si pas d'utilisateur en mémoire, essayer de l'initialiser
//       await initializeUser();
//       return;
//     }
    
//     try {
//       // Récupérer les données depuis Firestore
//       final userData = await DatabaseMethods().getUserDetails(_currentUser!.id);
      
//       if (userData != null) {
//         final UserModel updatedUser = UserModel.fromMap(userData);
//         await loginUser(updatedUser);
//         print('Données utilisateur rafraîchies');
//       }
//     } catch (e) {
//       print('Erreur lors du rafraîchissement des données: $e');
//     }
//   }

//   // Ajouter un workout au planning de l'utilisateur
//   // Future<void> addWorkoutToPlanning(Map<String, dynamic> workoutData) async {
//   //   if (_currentUser == null) {
//   //     throw Exception('Aucun utilisateur connecté');
//   //   }

//   //   try {
//   //     // Ajouter l'ID utilisateur aux données
//   //     workoutData['userId'] = _currentUser!.id;
      
//   //     await DatabaseMethods().addUserWorkoutDetails(workoutData, _currentUser!.id);
//   //     print('Workout ajouté pour l\'utilisateur: ${_currentUser!.name}');
//   //   } catch (e) {
//   //     throw Exception('Erreur lors de l\'ajout du workout: $e');
//   //   }
//   // }

//   // Validation des données utilisateur
//   bool isProfileComplete() {
//     if (_currentUser == null) return false;
    
//     return _currentUser!.name.isNotEmpty &&
//            _currentUser!.email.isNotEmpty &&
//            _currentUser!.age != null &&
//            _currentUser!.weight != null &&
//            _currentUser!.height != null;
//   }

//   // Forcer la réinitialisation (utile pour le debugging)
//   Future<void> forceReload() async {
//     _currentUser = null;
//     await initializeUser();
//   }
// }