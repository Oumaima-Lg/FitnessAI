import 'package:camera/camera.dart';
import 'package:fitness/services/fire_base_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitness/components/return_button.dart';
import 'package:flutter/material.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key});

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
    if (_cameraController.value.isInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  } 

  // bayna mn smiytha bach ngelbo lcam sayidati :)
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

  // Future<void> _takePhoto() async {
  //   if (!_cameraController.value.isInitialized) {
  //     return;
  //   }

  //   try {
  //     final XFile photo = await _cameraController.takePicture();

  //     // hna najoutew logic bach nenregistrew les photos mn be3d ... to be continued ...

  //     if (mounted) {
  //       Navigator.pop(context, photo.path);
  //     }
  //   } catch (e) {
  //     print('Erreur lors de la prise de photo: $e');
  //   }
  // }
  Future<void> _takePhoto() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      final XFile photo = await _cameraController.takePicture();

      // Upload la photo dans Firebase Storage + sauvegarde Firestore
      await uploadProgressPhoto(photo.path);

      if (mounted) {
        Navigator.pop(context, true); // tu peux renvoyer un booléen ou autre info
      }
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
      // Optionnel : afficher un message d'erreur à l'utilisateur
    }
  }


  ///******************************************** FIN METHODE DES ACTIONS ********************************************///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          // <-- Stack drnaha bachykono 3ndna layers mabin les widgets : src : "Stack provides a solution when you need to overlay widgets. For instance, if you want to display text over an image, the Stack widget is ideal for such scenarios."
          children: [
            // hna kifach ghadi tban lcamera sayidati :_:
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
                /************************************** FIN Header **************************************/

                /************************************** Section de la camera o tswera dyal lala sportif **************************************/
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
                                  color: Colors.white, size: 50),
                              SizedBox(height: 16),
                              Text(
                                'Permission denied',
                                style: TextStyle(color: Colors.white),
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

                /************************************** Barre des bouttons (camera/flash/switch cam) **************************************/
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

                /************************************** Barre des poses **************************************/
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
