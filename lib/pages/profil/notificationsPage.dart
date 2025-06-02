import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fitness/models/notification.dart';
import '../../components/textStyle/textstyle.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart'; // Pour le taptic feedback

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  final List<AppNotification> _notifications = [];
  bool _isMenuOpen = false;
  @override
  void initState() {
    super.initState();
    initialData();
  }

  // Fonction pour ajouter une notification avec feedback
  void addNotificationWithFeedback(AppNotification notification) {
    setState(() {
      _notifications.insert(
          0, notification); // Ajoute la notification en tête de liste
    });

    // Activer le taptic feedback
    Vibrate.feedback(
        FeedbackType.light); // Vous pouvez choisir le type de vibration
  }

  Future<void> initialData() async {
    // Ajout de notifications de test

    addNotificationWithFeedback(
      AppNotification(
        message: "Hey, let’s add some meals for your body goals",
        imagePath: 'images/icons/lunch1.png',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
      ),
    );
    addNotificationWithFeedback(
      AppNotification(
        message: "Congratulations, You have finished A..",
        imagePath: 'images/icons/workout2.png',
        timestamp: DateTime.now().subtract(
          const Duration(minutes: 20),
        ),
      ),
    );

    addNotificationWithFeedback(
      AppNotification(
        message: "Don’t miss your lowerbody workout",
        imagePath: 'images/icons/workout.png',
        timestamp: DateTime.now().subtract(
          const Duration(minutes: 15),
        ),
      ),
    );
    addNotificationWithFeedback(
      AppNotification(
        message: "Hey, it’s time for lunch",
        imagePath: 'images/icons/lunch.png',
        timestamp: DateTime.now(),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        path,
        width: 32,
        height: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: titleTextStyle(),
        ),
        actions: [
          IconButton(
            icon: _isMenuOpen
                ? Image.asset('images/icons/Close Square.png',
                    width: 32, height: 32)
                : Image.asset('images/icons/more.png', width: 32, height: 32),
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
              });

              showMenu(
                color: const Color(0xFF4E457B),
                context: context,
                position: RelativeRect.fromLTRB(50, 50, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                items: [
                  PopupMenuItem(
                      value: 'Delete All',
                      child: Container(
                        width: 141,
                        height: 43,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.delete, color: Colors.white),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                            ),
                            const Text('Delete All',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _notifications.clear();
                        });
                      }),
                ],
              ).then((_) {
                // Quand le menu se ferme
                setState(() {
                  _isMenuOpen = false;
                });
              });
            },
          ),
        ],
      ),
      // Ajouter une nouvelle notification avec feedback

      body: ListView.separated(
        padding: const EdgeInsets.only(top: 86),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withOpacity(0.2),
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          return ListTile(
            leading: _buildImage(notif.imagePath),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                showMenu(
                  color: const Color(0xFF4E457B),
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width -
                        200, // Adjusted left position
                    MediaQuery.of(context).viewPadding.top +
                        140 +
                        (index * 88), // Adjusted top position
                    16, // Right padding
                    0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Adjusted border radius
                  ),
                  items: [
                    PopupMenuItem(
                      height: 50, // Adjusted height
                      value: 'Delete',
                      child: Container(
                        width: 180, // Adjusted width
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.delete,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            const Text(
                              'Delete this notification',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _notifications.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            title: Text(
              notif.message,
              style: const TextStyle(
                color: Color(0xFFE9E3E4),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                height: 1.5,
                letterSpacing: 0,
              ),
            ),
            subtitle: Text(
              timeago.format(notif.timestamp),
              style: const TextStyle(
                color: Color(0xFFB6B4C1),
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                height: 1.5,
                letterSpacing: 0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          );
        },
      ),
    );
  }
}
