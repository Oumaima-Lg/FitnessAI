import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitness/components/return_button.dart';
import 'package:flutter/material.dart';

class TakePhotoPage extends StatefulWidget {
  final Function(List<String> photoPaths) onPhotosCompleted;

  const TakePhotoPage({super.key, required this.onPhotosCompleted});
  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  late CameraController _cameraController;
  List<CameraDescription> cameras = [];
  bool _isLoading = true;
  bool _isPermissionGranted = false;
  int _selectedPoseIndex = 0;
  bool _isFrontCamera = true;

  List<String> _photoPaths = [];

  final List<String> _poseImages = [
    'images/progress/front_position_cam.png',
    'images/progress/right_side_position.png',
    'images/progress/left_side_position.png',
    'images/progress/back_side_position.png',
  ];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  /// ****************************************** METHODE DES ACTIONS *******************************************///

  /// initialisation de camera ::
  Future<void> _initCamera() async {
    // AWAL HAJA KHASSNA NTCHEKEW L PERMISSIONS WACH 3NDNA ^_- :
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status.isGranted;
    });

    if (!status.isGranted) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // bach neste3mlo l front camera par defaut :
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors de l\'initialisation de la camera: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // nglbo l cam :)
  Future<void> _switchCamera() async {
    if (cameras.length < 2) return;

    setState(() {
      _isLoading = true;
      _isFrontCamera = !_isFrontCamera;
    });

    final newCameraIndex = _isFrontCamera
        ? cameras.indexWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : cameras.indexWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    if (newCameraIndex >= 0) {
      await _cameraController.dispose();

      _cameraController = CameraController(
        cameras[newCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    if (!_cameraController.value.isInitialized) return;

    // hna nshowi dialog dyal loading bach l utilisateur ychouf wach kayn chi haja li kat tsawer
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final XFile photo = await _cameraController.takePicture();

      // Hna ansawbo dossier local li anheto fih tsawer
      final Directory appDir = await getApplicationDocumentsDirectory();
      final DateTime now = DateTime.now();
      final String monthFolder = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final Directory monthDir = Directory('${appDir.path}/progress_photos/$monthFolder');
      
      if (!await monthDir.exists()) {
        await monthDir.create(recursive: true);
      }

      // le nom du fichier
      final String poseName = 'pose_${_selectedPoseIndex + 1}';
      final String fileName = '${now.millisecondsSinceEpoch}_$poseName.jpg';
      final String filePath = '${monthDir.path}/$fileName';

      // ncopiw tswira l local
      final File localFile = File(filePath);
      await localFile.writeAsBytes(await photo.readAsBytes());

      // ajouter à la liste 
      _photoPaths.add(filePath);

      // ndiro liha savec f firebase 
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('progress_photos')
            .add({
          'pose': poseName,
          'poseIndex': _selectedPoseIndex,
          'localPath': filePath,
          'month': monthFolder,
          'timestamp': FieldValue.serverTimestamp(),
          'createdAt': now.toIso8601String(),
        });
      }
      Navigator.of(context).pop();

      if (_selectedPoseIndex < _poseImages.length - 1) {
        setState(() {
          _selectedPoseIndex++;
        });
        
        // Afficher un message de confirmation
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Photo $poseName prise avec succès !'),
        //     duration: Duration(seconds: 2),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        // Toutes les photos sont prises
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Toutes les photos ont été prises avec succès !'),
        //     duration: Duration(seconds: 2),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        // Attendre un peu avant de retourner pour que l'utilisateur voit le message
        // await Future.delayed(Duration(seconds: 1));
        
        // Appeler le callback et retourner
        widget.onPhotosCompleted(_photoPaths);
        Navigator.pop(context, _photoPaths);
      }
      
    } catch (e) {
      // Fermer le dialog de chargement en cas d'erreur
      Navigator.of(context).pop();
      
      print('Erreur lors de la prise de photo: $e');
      
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la prise de photo: ${e.toString()}'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          // <-- Stack drnaha bachykono 3ndna layers mabin les widgets : src : "Stack provides a solution when you need to overlay widgets. For instance, if you want to display text over an image, the Stack widget is ideal for such scenarios."
          children: [
            // hna kifach ghadi tban lcamera :_:
            if (!_isLoading &&
                _isPermissionGranted &&
                _cameraController.value.isInitialized)
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController.value.previewSize!.height,
                    height: _cameraController.value.previewSize!.width,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ),
            Column(
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
                    ],
                  ),
                ),
                /************************************** Header dyal la page **************************************/
                /************************************** Section de la camera o tswera dyal sportif **************************************/
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_isLoading)
                        Center(child: CircularProgressIndicator())
                      else if (!_isPermissionGranted)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt,
                                color: Colors.white, 
                                size: 50
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Permission denied',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  await openAppSettings();
                                },
                                child: Text('Open Settings'),
                              ),
                            ],
                          ),
                        )
                      else if (!_cameraController.value.isInitialized)
                        Center(
                          child: Text(
                            'Camera not initialized',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      Center(
                        child: Image.asset(
                          _poseImages[_selectedPoseIndex],
                          height: MediaQuery.of(context).size.height * 0.6,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                /************************************** FIN Section de la camera **************************************/
                /**************************************  Hna la barre des bouttons (camera/flash/switch cam) **************************************/
                Container(
                  height: 68,
                  width: 295,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2E2F55).withAlpha(80),
                        Color(0xFF23253C).withAlpha(80),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /************ Flash ************/
                      IconButton(
                        icon: Icon(Icons.electric_bolt, color: Colors.white),
                        onPressed: () {
                          // Logique pour activer/désactiver le flash
                        },
                      ),
                      /************ Prendre la photo ************/
                      GestureDetector(
                        onTap: _takePhoto,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFF1A3B2), Color(0xFFEB62BC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      /************ Switch Camera ************/
                      IconButton(
                        icon: Icon(Icons.cameraswitch, color: Colors.white),
                        onPressed: _switchCamera,
                      ),
                    ],
                  ),
                ),
                /************************************** FIN Barre des bouttons **************************************/
                const SizedBox(height: 20),
                /************************************** hna la barre deyal les poses li kaynin **************************************/
                Container(
                  height: 130,
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      _poseImages.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPoseIndex = index;
                          });
                        },
                        child: Container(
                          width: 67.5,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _selectedPoseIndex == index
                                ? Color(0xFFF7F8F8)
                                : Color(0xFFDDDADA).withAlpha(10),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                            _poseImages[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /************************************** FIN Barre des poses **************************************/
              ],
            ),
          ],
        ),
      ),
    );
  }
}