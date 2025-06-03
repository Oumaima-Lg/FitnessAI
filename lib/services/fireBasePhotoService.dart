import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un dossier local basé sur la date
  Future<Directory> _getLocalDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    final Directory monthDir = Directory('${appDir.path}/progress_photos/$currentMonth');
    
    if (!await monthDir.exists()) {
      await monthDir.create(recursive: true);
    }
    
    return monthDir;
  }

  // Sauvegarder l'image localement
  Future<File> _saveImageLocally(File imageFile) async {
    final Directory localDir = await _getLocalDirectory();
    final String timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final String fileName = 'progress_$timestamp.jpg';
    final String localPath = '${localDir.path}/$fileName';
    
    return await imageFile.copy(localPath);
  }

  // Uploader l'image sur Firebase Storage
  Future<String?> _uploadToFirebase(File imageFile, String userId) async {
    try {
      final String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
      final String timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final String fileName = 'progress_$timestamp.jpg';
      
      final Reference ref = _storage
          .ref()
          .child('users')
          .child(userId)
          .child('progress_photos')
          .child(currentMonth)
          .child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Erreur lors de l\'upload Firebase: $e');
      return null;
    }
  }

  // Sauvegarder les métadonnées dans Firestore
  Future<bool> _saveMetadataToFirestore({
    required String userId,
    required String imageUrl,
    required String localPath,
    String? note,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress_photos')
          .add({
        'imageUrl': imageUrl,
        'localPath': localPath,
        'timestamp': FieldValue.serverTimestamp(),
        'month': DateFormat('yyyy-MM').format(DateTime.now()),
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'note': note ?? '',
        'createdAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des métadonnées: $e');
      return false;
    }
  }

  // Méthode principale pour sauvegarder une image
  Future<Map<String, dynamic>?> saveProgressImage({
    required File imageFile,
    required String userId,
    String? note,
  }) async {
    try {
      // 1. Sauvegarder localement
      final File localFile = await _saveImageLocally(imageFile);
      
      // 2. Uploader sur Firebase
      final String? firebaseUrl = await _uploadToFirebase(imageFile, userId);
      
      if (firebaseUrl == null) {
        throw Exception('Échec de l\'upload Firebase');
      }
      
      // 3. Sauvegarder les métadonnées
      final bool metadataSaved = await _saveMetadataToFirestore(
        userId: userId,
        imageUrl: firebaseUrl,
        localPath: localFile.path,
        note: note,
      );
      
      if (!metadataSaved) {
        throw Exception('Échec de la sauvegarde des métadonnées');
      }
      
      return {
        'success': true,
        'localPath': localFile.path,
        'firebaseUrl': firebaseUrl,
        'message': 'Image sauvegardée avec succès'
      };
      
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'image: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Erreur lors de la sauvegarde'
      };
    }
  }

  // Récupérer les images par mois
  Future<List<Map<String, dynamic>>> getImagesByMonth({
    required String userId,
    String? month, // Format: 'yyyy-MM'
  }) async {
    try {
      final String targetMonth = month ?? DateFormat('yyyy-MM').format(DateTime.now());
      
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress_photos')
          .where('month', isEqualTo: targetMonth)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des images: $e');
      return [];
    }
  }

  // Récupérer tous les mois disponibles
  Future<List<String>> getAvailableMonths(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress_photos')
          .get();

      final Set<String> months = <String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['month'] != null) {
          months.add(data['month']);
        }
      }

      final List<String> sortedMonths = months.toList()..sort();
      return sortedMonths.reversed.toList(); // Plus récent en premier
    } catch (e) {
      debugPrint('Erreur lors de la récupération des mois: $e');
      return [];
    }
  }

  // Supprimer une image
  Future<bool> deleteImage({
    required String userId,
    required String imageId,
    required String imageUrl,
    String? localPath,
  }) async {
    try {
      // Supprimer de Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress_photos')
          .doc(imageId)
          .delete();

      // Supprimer de Firebase Storage
      try {
        final Reference ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      } catch (e) {
        debugPrint('Erreur lors de la suppression Firebase Storage: $e');
      }

      // Supprimer le fichier local
      if (localPath != null) {
        try {
          final File localFile = File(localPath);
          if (await localFile.exists()) {
            await localFile.delete();
          }
        } catch (e) {
          debugPrint('Erreur lors de la suppression locale: $e');
        }
      }

      return true;
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'image: $e');
      return false;
    }
  }

  // Vérifier si une image locale existe
  Future<bool> localImageExists(String localPath) async {
    try {
      final File file = File(localPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  // Nettoyer les anciennes images locales (optionnel)
  Future<void> cleanOldLocalImages({int daysToKeep = 30}) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory progressDir = Directory('${appDir.path}/progress_photos');
      
      if (await progressDir.exists()) {
        final DateTime cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
        
        await for (FileSystemEntity entity in progressDir.list(recursive: true)) {
          if (entity is File) {
            final FileStat stat = await entity.stat();
            if (stat.modified.isBefore(cutoffDate)) {
              await entity.delete();
              debugPrint('Image locale supprimée: ${entity.path}');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur lors du nettoyage: $e');
    }
  }

  Future<Directory> _getMonthDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final DateTime now = DateTime.now();
    final String monthFolder = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final Directory monthDir = Directory('${appDir.path}/progress_photos/$monthFolder');
    
    if (!await monthDir.exists()) {
      await monthDir.create(recursive: true);
    }
    
    return monthDir;
  }
}