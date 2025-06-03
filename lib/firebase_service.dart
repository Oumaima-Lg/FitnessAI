import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/models/userStats.dart';
import 'package:intl/intl.dart';

// Enregistre UNIQUEMENT les stats du jour
Future<void> saveDailyStats(UserStats stats) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final today = DateTime.now().toIso8601String().split('T')[0];
  
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('dailyStats')
      .doc(today)
      .set({
        ...stats.toMap(),
        'date': today,
        'timestamp': FieldValue.serverTimestamp(),
      });
}

// Récupère les stats d'un jour spécifique
Future<UserStats?> getDailyStats(String date) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dailyStats')
        .doc(date)
        .get();

    return doc.exists ? UserStats.fromMap(doc.data()!) : null;
  } catch (e) {
    print("Erreur récupération stats du $date: $e");
    return null;
  }
}

// Récupère les stats d'aujourd'hui
Future<UserStats?> getTodayStats() async {
  final today = DateTime.now().toIso8601String().split('T')[0];
  return await getDailyStats(today);
}

// Stream des dernières stats journalières
Stream<List<UserStats>> getDailyStatsStream({int limit = 30}) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('dailyStats')
      .orderBy('timestamp', descending: true)
      .limit(limit)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserStats.fromMap(doc.data()))
          .toList());
}

// Met à jour uniquement certaines valeurs pour aujourd'hui
Future<void> updateTodayStats(Map<String, dynamic> partialStats) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final today = DateTime.now().toIso8601String().split('T')[0];
  
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('dailyStats')
      .doc(today)
      .set(partialStats, SetOptions(merge: true));
}

Future<int> getDailyWorkoutTotal(DateTime date) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 0;

  final dateKey = DateFormat('yyyy-MM-dd').format(date);
  
  try {
    final doc = await FirebaseFirestore.instance
        .collection('user_workouts')
        .doc(user.uid)
        .collection('daily_sessions')
        .doc(dateKey)
        .get();

    if (!doc.exists || doc.data() == null) return 0;

    final workouts = doc.data()!['workouts'] as List? ?? [];

    // Solution robuste pour la somme
    int total = 0;
    for (final workout in workouts.cast<Map<String, dynamic>>()) {
      final duration = workout['duration'];
      if (duration is int) {
        total += duration;
      } else if (duration is double) {
        total += duration.round();
      }
      // Ignore les autres types
    }
    return total;
    
  } catch (e) {
    print('Erreur lors du calcul: $e');
    return 0;
  }
}

Future<Map<String, dynamic>> getWorkoutsByDate(DateTime date) async {
  final dateKey = DateFormat('yyyy-MM-dd').format(date);
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};
  final doc = await FirebaseFirestore.instance
      .collection('user_workouts')
      .doc(user.uid)
      .collection('daily_sessions')
      .doc(dateKey)
      .get();

  return doc.data() ?? {};
} 