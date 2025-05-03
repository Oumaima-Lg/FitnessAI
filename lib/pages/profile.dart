import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';

Widget profile() {
  return ProfilePage();
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23253C),
      body: Column(
        children: [
          // Container avec gradient en haut et photo de profil
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // Gradient en haut
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Color.fromARGB(255, 253, 13, 146).withOpacity(0.6),
                      Color.fromARGB(255, 253, 13, 146).withOpacity(0.0),
                    ],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
              // Photo de profil qui déborde du gradient
              Positioned(
                bottom: -10,
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
                              width: 3,
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
                            child: Image.asset(
                              'assets/fentes.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
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
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Color(0xFFE84F8A), width: 1),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Color(0xFFE84F8A),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
          SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                // Informations utilisateur
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                        icon: Icons.height,
                        value: "165.0 CM",
                        label: "Height",
                        bgColor: Color.fromARGB(168, 232, 79, 138),
                      ),
                      _buildInfoCard(
                        icon: Icons.fitness_center,
                        value: "70.0 KG",
                        label: "Weight",
                        bgColor: Color.fromARGB(143, 69, 175, 194),
                      ),
                      _buildInfoCard(
                        icon: Icons.hourglass_bottom_outlined,
                        value: "22.9",
                        label: "Age",
                        bgColor: Color.fromARGB(121, 247, 207, 29),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            child: _buildMenuButton('Edit profile', Icons.person_outline, () {}),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton('Notification', Icons.notifications_outlined, () {}),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton('Delete my account', Icons.delete_outline, () {}, isDestructive: true),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton('Log out', Icons.logout, () {}),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '', backgroundColor: Color(0xFF373856)),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '', backgroundColor: Color(0xFF373856)),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: '', backgroundColor: Color(0xFF373856)),
            BottomNavigationBarItem(icon: Icon(Iconsax.activity), label: '', backgroundColor: Color(0xFF373856)),
            BottomNavigationBarItem(icon: Icon(Iconsax.profile_circle), label: '', backgroundColor: Color(0xFF373856)),
          ],
          showSelectedLabels: false,
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, VoidCallback onPressed, {bool isDestructive = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D4A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isDestructive ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String value,
    required String label,
    required Color bgColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}