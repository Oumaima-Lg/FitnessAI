import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Créez une instance du plugin de notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ID du canal de notification
  static const String _channelId = 'notifications_test_channel';
  static const String _channelName = 'Notifications Test Channel';
  static const String _channelDescription = 'Channel for testing notifications';

  // Initialiser les notifications
  Future<void> initializeNotifications() async {
    // Configuration pour Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration générale
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialiser le plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Créer le canal de notification (obligatoire pour Android 8.0+)
    await _createNotificationChannel();
  }

  // Gestionnaire pour les clics sur les notifications
  void _onNotificationTap(NotificationResponse details) {
    print('Notification tapped: ${details.payload}');
    // Vous pouvez ajouter ici la logique pour gérer les clics sur les notifications
  }

  // Créer le canal de notification
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high, // Importance élevée pour les notifications
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Afficher une notification simple
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    bool playSound = true,
    bool enableVibration = true,
  }) async {
    // Configuration des détails pour Android
    final AndroidNotificationDetails
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: playSound,
      enableVibration: enableVibration,
      // Pour ajouter un son personnalisé:
      // sound: const RawResourceAndroidNotificationSound('notification_sound'),
      // Pour ajouter un motif de vibration personnalisé:
      // vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
    );

    // Configuration générale
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Générer un ID unique basé sur le temps pour éviter les problèmes de notification
    final int uniqueId =
        id == 0 ? DateTime.now().millisecondsSinceEpoch ~/ 1000 : id;

    // Afficher la notification
    await flutterLocalNotificationsPlugin.show(
      uniqueId,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Méthode pour annuler une notification spécifique
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Méthode pour annuler toutes les notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}