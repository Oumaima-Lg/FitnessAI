import 'dart:convert';
import 'package:fitness/components/return_button.dart';
import 'package:fitness/pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness/models/photo.dart';

class FullGallery extends StatefulWidget {
  const FullGallery({super.key});

  @override
  State<FullGallery> createState() => _FullGalleryState();
}

class _FullGalleryState extends State<FullGallery> {

  List<Photo> _photos = [];
  Map<String, List<Photo>> _photoGroups = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  ///*********************************** DEBUT METHODES ***********************************///
  Future<void> _loadPhotos() async {
    try {
      final String response =
          await rootBundle.loadString('lib/data/photo.json');
      final List<dynamic> data = json.decode(response);

      _photos = data.map((item) => Photo.fromJson(item)).toList();

      _groupPhotosByDate();

      setState(() { 
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des photos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _groupPhotosByDate() {
    _photoGroups = {};

    for (var photo in _photos) {
      if (photo.date != null) {
        String dateKey = _formatDate(photo.date!);

        if (!_photoGroups.containsKey(dateKey)) {
          _photoGroups[dateKey] = [];
        }

        _photoGroups[dateKey]!.add(photo);
      }
    }
  }

  String _formatDate(String dateString) {
    // ila kant la date deja June 7 matalan ghadi tb9a kifma hiya
    if (!dateString.contains('-')) {
      return dateString;
    }

    // ila l9aha b7al hakda "YYYY-MM-DD" ghadi ndirlolha format l "DD Month"
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${date.day} ${months[date.month - 1]}';
    } catch (e) {
      print('Erreur lors du formatage de la date: $e');
      return dateString;
    }
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
              // Ce Expanded est crucial pour éviter l'overflow
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _photoGroups.isEmpty
                        ? const Center(
                            child: Text('Aucune photo disponible',
                                style: TextStyle(color: Colors.white)))
                        : Padding(
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
          child: Text(
            date,
            style: const TextStyle(
              color: Color(0xFFB55F75),
              fontSize: 12,
            ),
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
            return _buildPhotoThumbnail(photos[index].path ?? '');
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String imagePath) {
    return GestureDetector(
      onTap: () {
        // Show full size photo
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

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
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TakePhotoPage()),
          );
        },
      ),
    );
  }
  ///************************************** FIN widgets dyal les photo **************************************/
}