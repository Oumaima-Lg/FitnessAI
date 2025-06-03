import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String? id;
  final String? path;
  final String? pose;
  final int? poseIndex;
  final Timestamp? timestamp;
  final String? month;

  Photo({
    this.id,
    this.path,
    this.pose,
    this.poseIndex,
    this.timestamp,
    this.month,
  });

  // Constructeur pour créer une Photo depuis Firestore
  factory Photo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Photo(
      id: doc.id,
      path: data['localPath'] ?? data['path'],
      pose: data['pose'],
      poseIndex: data['poseIndex'],
      timestamp: data['timestamp'],
      month: data['month'],
    );
  }

  // Méthode pour convertir en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'localPath': path,
      'pose': pose,
      'poseIndex': poseIndex,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      'month': month,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Méthode pour créer une copie avec modifications
  Photo copyWith({
    String? id,
    String? path,
    String? pose,
    int? poseIndex,
    Timestamp? timestamp,
    String? month,
  }) {
    return Photo(
      id: id ?? this.id,
      path: path ?? this.path,
      pose: pose ?? this.pose,
      poseIndex: poseIndex ?? this.poseIndex,
      timestamp: timestamp ?? this.timestamp,
      month: month ?? this.month,
    );
  }

  @override
  String toString() {
    return 'Photo(id: $id, path: $path, pose: $pose, month: $month)';
  }
}