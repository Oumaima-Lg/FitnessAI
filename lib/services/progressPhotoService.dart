
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitness/models/photo.dart';

class ProgressPhotoService {
  Widget buildPhotoThumbnail(Photo photo) {
    final file = File(photo.path ?? '');
    return GestureDetector(
      onTap: () {
        print('Photo tappée: ${photo.path}');
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 100,
          maxWidth: 100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.withAlpha(50),
          image: DecorationImage(
            image: file.existsSync() 
                ? FileImage(file) 
                : AssetImage('images/placeholder.png') as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: !file.existsSync() 
            ? Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white.withAlpha(128),
                  size: 24,
                ),
              )
            : null,
      ),
    );
  }
}