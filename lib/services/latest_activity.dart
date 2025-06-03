// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:fitness/models/latest_activity.dart';
// // import 'package:path_provider/path_provider.dart';

// // class LatestActivityManager {
// //   static final LatestActivityManager _instance =
// //       LatestActivityManager._internal();
// //   factory LatestActivityManager() => _instance;
// //   LatestActivityManager._internal();

// //   List<LatestActivity> _activities = [];
// //   late String _filePath;

// //   Future<void> initialize() async {
// //     _filePath = 'lib/data/latestActivityData.json';
// //     await _ensureFileExists();
// //     await loadActivities();
// //   }

// //   Future<void> _ensureFileExists() async {
// //     final file = File(_filePath);
// //     if (!await file.exists()) {
// //       await file.create(recursive: true);
// //       await file.writeAsString('[]');
// //     }
// //   }

// //   Future<void> loadActivities() async {
// //     try {
// //       final file = File(_filePath);
// //       final contents = await file.readAsString();
// //       final List<dynamic> jsonList = json.decode(contents);
// //       _activities =
// //           jsonList.map((json) => LatestActivity.fromJson(json)).toList();
// //       sortActivitiesByCreatedAt(descending: false);
// //     } catch (e) {
// //       print('Error loading activities: $e');
// //       _activities = [];
// //     }
// //   }

// //   Future<void> saveActivities() async {
// //     try {
// //       final file = File(_filePath);
// //       final jsonList =
// //           _activities.map((activity) => activity.toJson()).toList();
// //       await file.writeAsString(json.encode(jsonList));
// //     } catch (e) {
// //       print('Error saving activities: $e');
// //     }
// //   }

// //   void addActivity(LatestActivity activity) {
// //     // Génère un ID si non fourni
// //     activity.id ??= DateTime.now().millisecondsSinceEpoch;
// //     _activities.add(activity);
// //   }

// //   List<LatestActivity> get activities => List.unmodifiable(_activities);

// //   // Pour supprimer une activité
// //   void removeActivity(int id) {
// //     _activities.removeWhere((activity) => activity.id == id);
// //   }

// //   void sortActivitiesByCreatedAt({bool descending = true}) {
// //     _activities.sort((a, b) {
// //       final aDate = a.createdAt;
// //       final bDate = b.createdAt;

// //       // Gestion des valeurs null (placées à la fin)
// //       if (aDate == null && bDate == null) return 0;
// //       if (aDate == null) return 1;
// //       if (bDate == null) return -1;

// //       // Comparaison normale
// //       return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
// //     });
// //   }
// // }


// import 'dart:convert';
// import 'dart:io';
// import 'package:fitness/models/latest_activity.dart';
// import 'package:path_provider/path_provider.dart';

// class LatestActivityManager {
//   static final LatestActivityManager _instance =
//       LatestActivityManager._internal();
//   factory LatestActivityManager() => _instance;
//   LatestActivityManager._internal();

//   List<LatestActivity> _activities = [];
//   late String _filePath;

//   Future<void> initialize() async {
//     // Utilise le répertoire approprié pour l'application
//     final directory = await getApplicationDocumentsDirectory();
//     _filePath = '${directory.path}/data/latestActivityData.json';
//     await _ensureFileExists();
//     await loadActivities();
//   }

//   Future<void> _ensureFileExists() async {
//     final file = File(_filePath);
//     if (!await file.exists()) {
//       // Crée le répertoire parent si nécessaire
//       await file.parent.create(recursive: true);
//       await file.create(recursive: true);
//       await file.writeAsString('[]');
//     }
//   }

//   Future<void> loadActivities() async {
//     try {
//       final file = File(_filePath);
//       if (await file.exists()) {
//         final contents = await file.readAsString();
//         final List<dynamic> jsonList = json.decode(contents);
//         _activities =
//             jsonList.map((json) => LatestActivity.fromJson(json)).toList();
//         sortActivitiesByCreatedAt(descending: false);
//       } else {
//         _activities = [];
//       }
//     } catch (e) {
//       print('Error loading activities: $e');
//       _activities = [];
//     }
//   }

//   Future<void> saveActivities() async {
//     try {
//       final file = File(_filePath);
//       // Assure-toi que le répertoire parent existe
//       if (!await file.parent.exists()) {
//         await file.parent.create(recursive: true);
//       }
//       final jsonList =
//           _activities.map((activity) => activity.toJson()).toList();
//       await file.writeAsString(json.encode(jsonList));
//     } catch (e) {
//       print('Error saving activities: $e');
//     }
//   }

//   void addActivity(LatestActivity activity) {
//     // Génère un ID si non fourni
//     activity.id ??= DateTime.now().millisecondsSinceEpoch;
//     _activities.add(activity);
//   }

//   List<LatestActivity> get activities => List.unmodifiable(_activities);

//   // Pour supprimer une activité
//   void removeActivity(int id) {
//     _activities.removeWhere((activity) => activity.id == id);
//   }

//   void sortActivitiesByCreatedAt({bool descending = true}) {
//     _activities.sort((a, b) {
//       final aDate = a.createdAt;
//       final bDate = b.createdAt;

//       // Gestion des valeurs null (placées à la fin)
//       if (aDate == null && bDate == null) return 0;
//       if (aDate == null) return 1;
//       if (bDate == null) return -1;

//       // Comparaison normale
//       return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
//     });
//   }
// }