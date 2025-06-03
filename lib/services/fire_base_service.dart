import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/models/latest_activity.dart';
import 'package:path/path.dart';

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

Future<void> uploadProgressPhoto(String path, {required String pose}) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final fileName = '${DateTime.now().millisecondsSinceEpoch}_$pose.jpg';

  final ref = FirebaseStorage.instance
      .ref()
      .child('progress_photos')
      .child(userId)
      .child(pose)
      .child(fileName);

  await ref.putFile(File(path));

  final downloadUrl = await ref.getDownloadURL();

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress_photos')
      .add({
    'url': downloadUrl,
    'pose': pose,
    'timestamp': FieldValue.serverTimestamp(),
  });
}
