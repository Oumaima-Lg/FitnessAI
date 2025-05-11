import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerHandler {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  // Méthode pour prendre une photo avec la caméra
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );
      
      if (photo != null) {
        selectedImage = File(photo.path);
        return selectedImage;
      }
    } catch (e) {
      debugPrint('Erreur lors de la prise de photo: $e');
    }
    return null;
  }

  // Méthode pour sélectionner une image de la galerie
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (image != null) {
        selectedImage = File(image.path);
        return selectedImage;
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection de l\'image: $e');
    }
    return null;
  }

  
}