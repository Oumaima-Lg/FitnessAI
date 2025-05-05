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

      // bach nsignaler la fin du chargement des photos mn le file json ^_- wt7iyed hadik l3iba dyal loading sayidati :
      setState(() { 
      // ^--> kanste3mlo setState sayidati to cause a rebuild of the widget and it's descendants hna fhad L7ala fach ghadi ndiro false ghadi trebuilda wila kant true twli false :).
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
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Container(

        /********* BG ********/
        padding: EdgeInsets.only(bottom: 10, top: 10),
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /************************************** Header dyal la page **************************************/
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        ReturnButton.returnButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Flexible(
                          child: Align(
                            // alignment: Alignment.center,
                            child: Text(
                              'Gallery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        _buildCameraButton(),
                      ],
                    ),
                  ),
                  /************************************** FIN Header **************************************/

                  const SizedBox(height: 20),

                  /******************************** GRILLE DYAL LES PHOTO **********************************/
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _photoGroups.isEmpty
                                  ? Center(
                                      child: Text('Aucune photo disponible',
                                          style:
                                              TextStyle(color: Colors.white)))
                                  : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            _photoGroups.entries.map((entry) {
                                          return _buildPhotoGroup(
                                              entry.key, entry.value);
                                        }).toList(),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),

                  /******************************** FIN GRILLE  **********************************/
                ],
              )
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
          padding: const EdgeInsets.only(left: 2, bottom: 8),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String imagePath) {
    return GestureDetector(
      onTap: () {
        // Show full size photo
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 100,
          maxWidth: 100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return Container(
      width: 60,
      height: 60,
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
        iconSize: 30,
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
