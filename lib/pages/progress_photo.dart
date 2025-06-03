import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/components/return_button.dart';
import 'package:fitness/pages/camera_page.dart';
import 'package:fitness/pages/full_gallery.dart';
import 'package:fitness/services/progressPhotoService.dart';
import 'package:flutter/material.dart';
import 'package:fitness/models/photo.dart';
class ProgressePage extends StatefulWidget {
  final List<String> takenPhotoPaths;

  const ProgressePage({super.key, required this.takenPhotoPaths});

  @override
  State<ProgressePage> createState() => _ProgressePageState();
}

class _ProgressePageState extends State<ProgressePage> {
  List<Photo> _photos = []; // hna ge3 les imgs li kaynin f firebase
  Map<String, List<Photo>> _photoGroups = {}; // hna regroupina b date 
  Map<String, List<Photo>> _recentPhotoGroups = {};
  bool _isLoading = true;

  final int _recentGroupsCount = 2;
  final int _maxPhotosPerGroup = 30;

  final service = ProgressPhotoService();

  final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ];

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

      // Charger les photos depuis Firestore
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
        
        // Vérifier si le fichier existe localement
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
            // Si le fichier n'existe pas localement, le supprimer de Firestore
            await doc.reference.delete();
            print('Photo supprimée car fichier introuvable: $localPath');
          }
        }
      }

      setState(() {
        _photos = loadedPhotos;
        _photoGroups = _groupPhotosByDate(_photos);
        _recentPhotoGroups = _filterRecentPhotos(_photoGroups);
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

  // Grouper les photos par date (mois-année)
  Map<String, List<Photo>> _groupPhotosByDate(List<Photo> photos) {
    Map<String, List<Photo>> groups = {};
    
    for (Photo photo in photos) {
      String groupKey;
      
      if (photo.month != null && photo.month!.isNotEmpty) {
        // Utiliser le mois stocké dans Firestore
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
        // date actuelle
        final now = DateTime.now();
        final monthName = months[now.month - 1];
        groupKey = '$monthName ${now.year}';
      }
      
      if (!groups.containsKey(groupKey)) {
        groups[groupKey] = [];
      }
      groups[groupKey]!.add(photo);
    }
    
    // Trier les groupes par date (plus récent en premier)
    final sortedGroups = Map<String, List<Photo>>.fromEntries(
      groups.entries.toList()..sort((a, b) {
        // Convertir les noms de mois en dates pour le tri
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

  // gher tsawer deyal akhir 2 mois
  Map<String, List<Photo>> _filterRecentPhotos(Map<String, List<Photo>> photoGroups) {
    final entries = photoGroups.entries.take(_recentGroupsCount).toList();
    return Map<String, List<Photo>>.fromEntries(entries);
  }

  // hna bash itel3o lina tsawer li alah tzado kandiro refresh
  Future<void> _refreshPhotos() async {
    await _loadPhotosFromFirebase();
  }
  // hna bash itel3o lina popup li kayn fih infos 3la tracking de progression
  void _showInfoPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 326,
                  height: 403,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    color: Color(0xFF6273BD).withAlpha(100),
                    border: Border.all(
                      color: Color(0xFFFFFFFF).withAlpha(90),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 100,
                    left: 30,
                    right: 30,
                    bottom: 30,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Track Your Progress',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            "Tracking your progress each month with photo features in a mobile fitness app offers a visual and motivating way to witness your transformation over time. By snapping a monthly photo within the app, you create a chronological gallery that highlights changes in your physique, posture, and overall fitness. This visual timeline allows you to compare current and past images side-by-side, helping you recognize subtle improvements that might otherwise go unnoticed, such as muscle definition, posture adjustments, or fat loss. The app may also",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15,
                  child: Container(
                    width: 116,
                    height: 76,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/calendar.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(10),
                        border: Border.all(
                          color: Colors.white.withAlpha(97),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
  ///*********************************** FIN METHODES ***********************************///

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReturnButton.returnButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Progress Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Bouton refresh
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: _refreshPhotos,
                    ),
                  ],
                ),
                _buildProgressTrackingCard(screenWidth, screenHeight),
                const SizedBox(height: 20),
                // Gallery
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: 
                        () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullGallery(),
                          ),
                        );
                        // bash ndiro refresh f galery
                        _refreshPhotos();
                      },
                      child: const Text(
                        'See more',
                        style: TextStyle(
                          color: Color.fromARGB(255, 219, 196, 200),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _recentPhotoGroups.isEmpty
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
                                    'Take a photo to start tracking your progress',
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
                              child: ListView.builder(
                                itemCount: _recentPhotoGroups.entries.length,
                                itemBuilder: (context, index) {
                                  var entry = _recentPhotoGroups.entries.elementAt(index);
                                  return _buildPhotoGroup(entry.key, entry.value);
                                },
                              ),
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildComparePhotoButton(),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100, right: 10),
        child: _buildCameraButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProgressTrackingCard(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.03,
        left: screenWidth * 0.00,
        right: screenWidth * 0.00,
        bottom: screenHeight * 0.00,
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 137,
          minWidth: screenWidth * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9DCEFF).withAlpha(80),
              Color(0xFF92A3FD).withAlpha(70)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                        height: 2.0,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Track Your Progress Each Month With ',
                        ),
                        TextSpan(
                          text: 'Photo',
                          style: TextStyle(
                            color: Color(0xFF4C8EF5),
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ReturnButton.gradientButton(
                    'Learn More',
                    onPressed: () {
                      _showInfoPopup(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Image.asset(
                'images/calendar.png',
                width: 116,
                height: 76,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGroup(String date, List<Photo> photos) {
    final displayedPhotos = photos.length > _maxPhotosPerGroup
        ? photos.sublist(0, _maxPhotosPerGroup)
        : photos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
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
              if (photos.length > _maxPhotosPerGroup)
                Text(
                  '${photos.length} photos',
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
          itemCount: displayedPhotos.length,
          itemBuilder: (context, index) {
            return service.buildPhotoThumbnail(displayedPhotos[index]);
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

  Widget _buildComparePhotoButton() {
    return Container(
      width: 315,
      height: 57,
      padding: const EdgeInsets.only(left: 30, top: 12, bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF9DCEFF).withAlpha(50),
            Color(0xFF92A3FD).withAlpha(60)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Compare my Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ReturnButton.gradientButton(
                    'Compare',
                    onPressed: () {
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TakePhotoPage(
              onPhotosCompleted: (List<String> takenPhotoPaths) async {
                print('Photos prises: $takenPhotoPaths');
              },
            ),
          ),
        );
        if (result != null) {
          await _refreshPhotos();
        }
      },
      backgroundColor: Color(0xFF6273BD),
      child: Icon(Icons.camera_alt, color: Colors.white),
    );
  }
}