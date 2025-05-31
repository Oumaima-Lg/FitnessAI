import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String? url;
  final DateTime? date;

  Photo({this.url, this.date});

  factory Photo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Photo(
      url: data['url'] as String?,
      date: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        // Convertir DateTime en Timestamp pour Firestore
        'timestamp': date != null ? Timestamp.fromDate(date!) : null,
      };
}

class FirebasePhotoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Charger toutes les photos (peut être volumineux, donc à utiliser avec précaution)
  Future<List<Photo>> loadPhotos() async {
    final snapshot = await _firestore
        .collection('progress_photos')
        .orderBy('timestamp', descending: true) 
        .get();

    return snapshot.docs.map((doc) => Photo.fromFirestore(doc)).toList();
  }

  // Charger les photos d’un utilisateur spécifique
  Future<List<Photo>> loadPhotosForUser(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress_photos')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => Photo.fromFirestore(doc)).toList();
  }

  // hnaa kanjm3o tsawer bchehora (bhal: "2025-05")
  Map<String, List<Photo>> groupPhotosByDate(List<Photo> photos) {
    Map<String, List<Photo>> grouped = {};

    for (var photo in photos) {
      final date = photo.date ?? DateTime(1900); 
      final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(photo);
    }

    return grouped;
  }

  // Hna kanfeltriw les grps bash ib9aw gher akher 2 mois
  Map<String, List<Photo>> filterRecentPhotos(
    Map<String, List<Photo>> groups, {
    int recentGroupsCount = 2,
  }) {
    final sortedKeys = groups.keys.toList()
      ..sort((a, b) => b.compareTo(a)); 
    final recentKeys = sortedKeys.take(recentGroupsCount);
    return Map.fromEntries(
      recentKeys.map((k) => MapEntry(k, groups[k]!)),
    );
  }
}
