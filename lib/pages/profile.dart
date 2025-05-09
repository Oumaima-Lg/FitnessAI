import 'package:fitness/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:fitness/pages/EditProfilePage.dart';
import 'package:fitness/pages/notifications.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fitness/pages/ImagePicker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePickerHandler _imagePickerHandler = ImagePickerHandler();
  File? _profileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  // top: 0,
                  child: Image.asset(
                    'images/Ellipse Profil.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 290,
                  ),
                ),
                Positioned(
                  top: 30,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Cercle rose extérieur
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFE84F8A),
                                width: 2,
                              ),
                            ),
                          ),
                          // Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade300,
                            ),
                            child: ClipOval(
                              child: _profileImage != null
                                  ? kIsWeb
                                      ? Image.network(
                                          _profileImage!.path,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _profileImage!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset(
                                      'images/profilGirl.png',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                            ),
                          ),
                          // Icône de caméra positionnée en bas à droite
                          Positioned(
                            bottom: -4, // ajuste si nécessaire
                            right: 0,
                            child: DottedBorder(
                              color: Colors.white,
                              strokeWidth: 1.5,
                              dashPattern: [3, 2],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(4),
                              padding: EdgeInsets.zero,
                              child: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                offset: const Offset(0, 40),
                                color: const Color(0xFF4E457B).withAlpha(253),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20, // taille réduite
                                ),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'camera',
                                    child: Row(
                                      children: const [
                                        Icon(Icons.camera_alt,
                                            color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Take a photo',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'gallery',
                                    child: Row(
                                      children: const [
                                        Icon(Icons.photo_library,
                                            color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Choose from gallery',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (String value) async {
                                  if (value == 'camera') {
                                    final File? image =
                                        await _imagePickerHandler.takePhoto();
                                    if (image != null) {
                                      setState(() {
                                        _profileImage = image;
                                      });
                                    }
                                  } else if (value == 'gallery') {
                                    final File? image =
                                        await _imagePickerHandler
                                            .pickFromGallery();
                                    if (image != null) {
                                      setState(() {
                                        _profileImage = image;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Nom d'utilisateur
                      Text(
                        'Mophsic',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Localisation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Beijing Haidian-District',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(
                      imageUrl: 'images/heightIcon.png',
                      value: "165.0 CM",
                      label: "Height",
                      bgColor: Color.fromARGB(168, 232, 79, 138),
                    ),
                    _buildInfoCard(
                      imageUrl: 'images/weightIcon.png',
                      value: "70.0 KG",
                      label: "Weight",
                      bgColor: Color.fromARGB(143, 69, 175, 194),
                    ),
                    _buildInfoCard(
                      imageUrl: 'images/ageIcon.png',
                      value: "22.9 Year",
                      label: "Age",
                      bgColor: Color.fromARGB(121, 247, 207, 29),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton(
                                'Edit profile', Icons.person_outline, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton(
                                'Notification', Icons.notifications_outlined,
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationPage(),
                                ),
                              );
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton('Delete my account',
                                Icons.delete_outline, () {},
                                isDestructive: true),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child:
                                _buildMenuButton('Log out', Icons.logout, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed,
      {bool isDestructive = false}) {
    return Container(
      width: 305,
      height: 50,
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4E457B).withAlpha(127),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String imageUrl,
    required String value,
    required String label,
    required Color bgColor,
  }) {
    return Row(
      children: [
        Container(
          child: Image.asset(imageUrl),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFFEBEBF5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
