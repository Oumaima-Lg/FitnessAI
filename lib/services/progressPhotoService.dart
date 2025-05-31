import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fitness/models/photo.dart';

class ProgressPhotoService {
  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  ///*********************************** DEBUT METHODES ***********************************///

//   Future<List<Photo>> loadPhotos() async {
//     try {
//       final String response =
//           await rootBundle.loadString('lib/data/photo.json');
//       final List<dynamic> data = json.decode(response);

//       return data.map((item) => Photo.fromJson(item)).toList();
//     } catch (e) {
//       print('Erreur lors du chargement des photos: $e');
//       return [];
//     }
//   }

//   Map<String, List<Photo>> groupPhotosByDate(List<Photo> photos) {
//     Map<String, List<Photo>> photoGroups = {};

//     for (var photo in photos) {
//       if (photo.date != null) {
//         String dateKey = formatDate(photo.date!);

//         if (!photoGroups.containsKey(dateKey)) {
//           photoGroups[dateKey] = [];
//         }

//         photoGroups[dateKey]!.add(photo);
//       }
//     }

//     return photoGroups;
//   }

//   Map<String, List<Photo>> filterRecentPhotos(
//     Map<String, List<Photo>> photoGroups, {
//     int recentGroupsCount = 2,
//   }) {
//     var sortedEntries =
//         photoGroups.entries.toList() // kantriyew b les plus recentes dates
//           ..sort((a, b) {
//             //<-- parsing dyal les dates to avoid problems fima ba3d ;
//             try {
//               // Si le format est "DD Month"
//               final aParts = a.key.split(' ');
//               final bParts = b.key.split(' ');

//               if (aParts.length == 2 && bParts.length == 2) {
//                 final aMonth = months.indexOf(aParts[1]);
//                 final bMonth = months.indexOf(bParts[1]);

//                 if (aMonth != -1 && bMonth != -1) {
//                   // <-- awel haja tri par moi sayidati
//                   if (aMonth != bMonth) {
//                     return bMonth - aMonth;
//                   }

//                   return int.parse(bParts[0]) -
//                       int.parse(aParts[0]); // <-- mnmoraha par jrs
//                 }
//               }
//             } catch (e) {
//               print('Erreur lors du tri des dates: $e');
//             }

//             return b.key.compareTo(a.key); // tri alphabetique  wsf ^_^
//           });

//     Map<String, List<Photo>> recentPhotoGroups = {};
//     for (int i = 0; i < sortedEntries.length && i < recentGroupsCount; i++) {
//       var entry = sortedEntries[i];
//       recentPhotoGroups[entry.key] = entry.value;
//     }
// //  ^--> had la boucle sayidati bach nakhdo les N recentes
//     return recentPhotoGroups;
//   }

//   String formatDate(String dateString) {
//     // ila kant la date deja June 7 matalan ghadi tb9a kifma hiya
//     if (!dateString.contains('-')) {
//       return dateString;
//     }

//     // ila l9aha b7al hakda "YYYY-MM-DD" ghadi ndirlolha format l "DD Month"
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day} ${months[date.month - 1]}';
//     } catch (e) {
//       print('Erreur lors du formatage de la date: $e');
//       return dateString;
//     }
//   }

  ///*********************************** FIN METHODES ***********************************///
}
