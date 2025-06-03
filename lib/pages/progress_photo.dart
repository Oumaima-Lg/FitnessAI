import 'package:fitness/components/return_button.dart';
import 'package:fitness/pages/camera_page.dart';
import 'package:fitness/pages/full_gallery.dart';
import 'package:flutter/material.dart';
import 'package:fitness/models/photo.dart';
import 'package:fitness/services/progressPhotoService.dart';

class ProgressePage extends StatefulWidget {
  const ProgressePage({super.key});

  @override
  State<ProgressePage> createState() => _ProgressePageState();
}

class _ProgressePageState extends State<ProgressePage> {
  final ProgressPhotoService _photoService = ProgressPhotoService();

  List<Photo> _photos = [];
  Map<String, List<Photo>> _photoGroups = {};
  Map<String, List<Photo>> _recentPhotoGroups = {};
  bool _isLoading = true;

  final int _recentGroupsCount =
      2; // <-- hna ndiro ch7al bghina mn grp dyal les pic bghina ytafficha
  final int _maxPhotosPerGroup =
      8; // <-- hna ndiro ch7al bghina mn pic f grp dyal les pic bghina ytafficha sayidati

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

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  ///*********************************** DEBUT METHODES ***********************************///

  Future<void> _loadPhotos() async {
    try {
      _photos = await _photoService.loadPhotos();

      _photoGroups = _photoService.groupPhotosByDate(_photos);
      _recentPhotoGroups = _photoService.filterRecentPhotos(_photoGroups,
          recentGroupsCount: _recentGroupsCount);

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
    // les dimensions de l'écran 3la 9bel lresponsivite w dak chi sayidati :
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        /********* BG ********/
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Barre de titre avec bouton de retour
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
                    const SizedBox(width: 50),
                  ],
                ),

                // Card d'information sur le tracking de progression
                _buildProgressTrackingCard(screenWidth, screenHeight),

                const SizedBox(height: 20),

                // Entête Gallery
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullGallery(),
                          ),
                        );
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
                              child: Text('Aucune photo disponible',
                                  style: TextStyle(color: Colors.white)))
                          : ListView.builder(
                              itemCount: _recentPhotoGroups.entries.length,
                              itemBuilder: (context, index) {
                                var entry =
                                    _recentPhotoGroups.entries.elementAt(index);
                                return _buildPhotoGroup(entry.key, entry.value);
                              },
                            ),
                  //      ^
                  //      |---> flewel ghadi y tafficha dak cercle katlowda z3ma ^_^, then kayverifier ila kant la liste dyal
                  //      |     les photos khawya ghadi y afficher aucune photo .. f center dyal section , if l contraire ghadi y afficher
                  //      |     la gride dyal les photo récente ^_-;
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

      /********* Bouton flottant pour la caméra ********/
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100, right: 10),
        child: _buildCameraButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      /********* FIN DU BOUTON ********/
    );
  }

  Widget _buildProgressTrackingCard(double screenWidth, double screenHeight) {
    return Padding(
      // padding: const EdgeInsets.only(top: 10, left: 1, right: 1),
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
    //  ^--> hna sayidati ghadi nchofo ila kan l nombre dyal les photos f grp ktar mn li max n9et3o ghi li bghina , snn dak chi li bina ghadi tab9a la list kima hiya :)

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
          itemCount: displayedPhotos.length,
          itemBuilder: (context, index) {
            return _buildPhotoThumbnail(displayedPhotos[index].path ?? '');
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String imagePath) {
    return GestureDetector(
      onTap: () {},
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
          Row(
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
              const SizedBox(width: 10),
              ReturnButton.gradientButton(
                'Compare',
                onPressed: () {
                  // Action when button is pressed
                },
              )
            ],
          ),
        ],
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
}
