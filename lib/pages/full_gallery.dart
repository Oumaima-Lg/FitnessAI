import 'dart:convert';
import 'package:fitness/components/return_button.dart';
import 'package:fitness/pages/camera_page.dart';
import 'package:fitness/services/progressPhotoService.dart';
import 'package:flutter/material.dart';
import 'package:fitness/models/photo.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class FullGallery extends StatefulWidget {
  const FullGallery({super.key});

  @override
  State<FullGallery> createState() => _FullGalleryState();
}

class _FullGalleryState extends State<FullGallery> {
  List<Photo> _photos = [];
  Map<String, List<Photo>> _photoGroups = {};
  bool _isLoading = true;

  final service = ProgressPhotoService();

  final months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ];

  @override
  void initState() {
    super.initState();
    _loadPhotosFromFirebase();
  }
  ///*********************************** DEBUT METHODES ***********************************///
  Future<void> _loadPhotosFromFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      // njibo les imgs mn Firebase
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('progress_photos')
          .orderBy('timestamp', descending: true)
          .get();

      List<Photo> loadedPhotos = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String localPath = data['localPath'] ?? data['path'] ?? '';
        
        // kanverifiw wesh le fichier kayn f localPath
        if (localPath.isNotEmpty) {
          final File file = File(localPath);
          if (await file.exists()) {
            loadedPhotos.add(Photo(
              id: doc.id,
              path: localPath,
              pose: data['pose'] ?? '',
              poseIndex: data['poseIndex'] ?? 0,
              timestamp: data['timestamp'] as Timestamp?,
              month: data['month'] ?? '',
            ));
          } else {
            await doc.reference.delete();
            print('Photo supprimée car fichier introuvable: $localPath');
          }
        }
      }
      setState(() {
        _photos = loadedPhotos;
        _photoGroups = _groupPhotosByDate(_photos);
        _isLoading = false;
      });

    } catch (e) {
      print('Erreur lors du chargement des photos: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des photos: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // an grouipw gee3 les imgs par date 
  Map<String, List<Photo>> _groupPhotosByDate(List<Photo> photos) {
    Map<String, List<Photo>> groups = {};
    
    for (Photo photo in photos) {
      String groupKey;
      
      if (photo.month != null && photo.month!.isNotEmpty) {
        final parts = photo.month!.split('-');
        if (parts.length == 2) {
          final year = parts[0];
          final monthIndex = int.tryParse(parts[1]) ?? 1;
          final monthName = months[monthIndex - 1];
          groupKey = '$monthName $year';
        } else {
          groupKey = photo.month!;
        }
      } else if (photo.timestamp != null) {
        // Fallback sur le timestamp
        final date = photo.timestamp!.toDate();
        final monthName = months[date.month - 1];
        groupKey = '$monthName ${date.year}';
      } else {
        // Dernière option: date actuelle
        final now = DateTime.now();
        final monthName = months[now.month - 1];
        groupKey = '$monthName ${now.year}';
      }
      
      if (!groups.containsKey(groupKey)) {
        groups[groupKey] = [];
      }
      groups[groupKey]!.add(photo);
    }
    
    // hna antrier les grps par date 
    final sortedGroups = Map<String, List<Photo>>.fromEntries(
      groups.entries.toList()..sort((a, b) {
        // hna gher bash kanhowlo noms de mois en dates pour le tri
        final aDate = _parseMonthYear(a.key);
        final bDate = _parseMonthYear(b.key);
        return bDate.compareTo(aDate);
      }),
    );
    
    return sortedGroups;
  }

  DateTime _parseMonthYear(String monthYear) {
    final parts = monthYear.split(' ');
    if (parts.length == 2) {
      final monthName = parts[0];
      final year = int.tryParse(parts[1]) ?? DateTime.now().year;
      final monthIndex = months.indexOf(monthName) + 1;
      return DateTime(year, monthIndex);
    }
    return DateTime.now();
  }

  // refresh l photos
  Future<void> _refreshPhotos() async {
    await _loadPhotosFromFirebase();
  }

  ///*********************************** FIN METHODES ***********************************///
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Container(
        /********* BG ********/
        width: double.infinity,
        height: double.infinity,
        /* background dégradé : */
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E2F55),
              Color(0xFF23253C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        /******************************/

        child: SafeArea(
          child: Column(
            children: [
              /************************************** Header dyal la page **************************************/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReturnButton.returnButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Gallery',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCameraButton(),
                  ],
                ),
              ),
              /************************************** FIN Header **************************************/
              const SizedBox(height: 10),
              /******************************** GRILLE DYAL LES PHOTO **********************************/
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _photoGroups.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera_outlined,
                                  size: 64,
                                  color: Colors.white.withAlpha(128),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No photos yet',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Capture your progress by taking photos regularly.',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(180),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshPhotos,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                itemCount: _photoGroups.length,
                                itemBuilder: (context, index) {
                                  String date = _photoGroups.keys.elementAt(index);
                                  List<Photo> photos = _photoGroups[date]!;
                                  return _buildPhotoGroup(date, photos);
                                },
                              ),
                            ),
                          ),
              ),
              /******************************** FIN GRILLE **********************************/
            ],
          ),
        ),
      ),
    );
  }

  ///************************************** widgets dyal les photo **************************************/
  Widget _buildPhotoGroup(String date, List<Photo> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 10, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFFB55F75),
                  fontSize: 12,
                ),
              ),
              Text(
                '${photos.length} photo${photos.length > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return service.buildPhotoThumbnail(photos[index]);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Widget _buildPhotoThumbnail(Photo photo) {
  //   final file = File(photo.path ?? '');
  //   return GestureDetector(
  //     onTap: () {
  //       print('Photo tappée: ${photo.path}');
  //     },
  //     child: Container(
  //       constraints: BoxConstraints(
  //         maxHeight: 100,
  //         maxWidth: 100,
  //       ),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(14),
  //         color: Colors.grey.withAlpha(50),
  //         image: DecorationImage(
  //           image: file.existsSync() 
  //               ? FileImage(file) 
  //               : AssetImage('images/placeholder.png') as ImageProvider,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       child: !file.existsSync() 
  //           ? Center(
  //               child: Icon(
  //                 Icons.broken_image,
  //                 color: Colors.white.withAlpha(128),
  //                 size: 24,
  //               ),
  //             )
  //           : null,
  //     ),
  //   );
  // }

  Widget _buildCameraButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFC58BF2), Color(0xFFEEA4CE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(92, 238, 164, 206),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(4, 1),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 20,
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakePhotoPage(
                onPhotosCompleted: (List<String> paths) {
                },
              ),
            ),
          );
          if (result != null) {
            await _refreshPhotos();
          }
        },
      ),
    );
  }
  ///************************************** FIN widgets dyal les photo **************************************/
}