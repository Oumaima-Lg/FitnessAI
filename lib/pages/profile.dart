import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
                              child: Image.asset(
                                'images/profilGirl.png',
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
                                border: Border.all(
                                    color: Color(0xFFE84F8A), width: 1),
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
                                'Edit profile', Icons.person_outline, () {}),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            width: double.infinity,
                            child: _buildMenuButton('Notification',
                                Icons.notifications_outlined, () {}),
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
                            child: _buildMenuButton(
                                'Log out', Icons.logout, () {}),
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
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(24),
          //     bottomRight: Radius.circular(24),
          //     topLeft: Radius.circular(24),
          //   ),
          // ),
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
          // padding: EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //   color: bgColor,
          //   borderRadius: BorderRadius.circular(12),
          // ),
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
