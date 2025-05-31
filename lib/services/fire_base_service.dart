import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/models/latest_activity.dart';

Future<void> saveLatestActivity({
  required String title,
  required String icon,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('latestActivity');

  await docRef.add({
    'title': title,
    'icon': icon,
    'createdAt': Timestamp.now(),
  });
}

Future<List<LatestActivity>> loadUserLatestActivities() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('latestActivity')
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return LatestActivity(
      id: doc.id,
      nameActivity: data['title'],
      imageUrl: data['icon'],
      createdAt: (data['createdAt'] as Timestamp).millisecondsSinceEpoch,
    );
  }).toList();
}

Future<String?> uploadProgressPhoto(String filePath) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw Exception("Utilisateur non connecté");

  try {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('progress_photos')
        .child(uid)
        .child('$fileName.jpg');

    // Upload du fichier
    await storageRef.putFile(File(filePath));

    // Récupérer le lien de téléchargement
    final downloadUrl = await storageRef.getDownloadURL();

    // Enregistrement dans Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('progress_photos')
        .add({
      'url': downloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return downloadUrl;
  } catch (e) {
    print('Erreur uploadProgressPhoto: $e');
    return null;
  }
}

