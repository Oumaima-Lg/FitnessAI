// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // Votre service de notification (inclus ici pour l'exemple complet)
// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static const String _channelId = 'notifications_test_channel';
//   static const String _channelName = 'Notifications Test Channel';
//   static const String _channelDescription = 'Channel for testing notifications';

//   Future<void> initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );

//     await _createNotificationChannel();
//   }

//   void _onNotificationTap(NotificationResponse details) {
//     print('Notification tapped: ${details.payload}');
//   }

//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       _channelId,
//       _channelName,
//       description: _channelDescription,
//       importance: Importance.high,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> showNotification({
//     int id = 0,
//     required String title,
//     required String body,
//     String? payload,
//     bool playSound = true,
//     bool enableVibration = true,
//   }) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       _channelId,
//       _channelName,
//       channelDescription: _channelDescription,
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//       playSound: playSound,
//       enableVibration: enableVibration,
//     );

//     final NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     final int uniqueId =
//         id == 0 ? DateTime.now().millisecondsSinceEpoch ~/ 1000 : id;

//     await flutterLocalNotificationsPlugin.show(
//       uniqueId,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }

//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }

//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Test Notifications',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: NotificationTestScreen(),
//     );
//   }
// }

// class NotificationTestScreen extends StatefulWidget {
//   @override
//   _NotificationTestScreenState createState() => _NotificationTestScreenState();
// }

// class _NotificationTestScreenState extends State<NotificationTestScreen> {
//   final NotificationService _notificationService = NotificationService();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();
//   final TextEditingController _payloadController = TextEditingController();
//   final TextEditingController _idController = TextEditingController();
  
//   bool _isInitialized = false;
//   bool _playSound = true;
//   bool _enableVibration = true;
//   int _notificationCounter = 1;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotifications();
    
//     // Valeurs par défaut pour les tests
//     _titleController.text = "Test Notification";
//     _bodyController.text = "Ceci est un test de notification";
//     _payloadController.text = "test_payload";
//   }

//   Future<void> _initializeNotifications() async {
//     try {
//       await _notificationService.initializeNotifications();
//       setState(() {
//         _isInitialized = true;
//       });
//       _showSnackBar("Service de notifications initialisé avec succès", Colors.green);
//     } catch (e) {
//       _showSnackBar("Erreur lors de l'initialisation: $e", Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   Future<void> _sendTestNotification() async {
//     if (!_isInitialized) {
//       _showSnackBar("Service non initialisé", Colors.red);
//       return;
//     }

//     try {
//       await _notificationService.showNotification(
//         title: _titleController.text.isEmpty ? "Test $_notificationCounter" : _titleController.text,
//         body: _bodyController.text.isEmpty ? "Message de test $_notificationCounter" : _bodyController.text,
//         payload: _payloadController.text.isEmpty ? null : _payloadController.text,
//         playSound: _playSound,
//         enableVibration: _enableVibration,
//       );
      
//       setState(() {
//         _notificationCounter++;
//       });
      
//       _showSnackBar("Notification envoyée avec succès", Colors.green);
//     } catch (e) {
//       _showSnackBar("Erreur lors de l'envoi: $e", Colors.red);
//     }
//   }

//   Future<void> _sendMultipleNotifications() async {
//     if (!_isInitialized) {
//       _showSnackBar("Service non initialisé", Colors.red);
//       return;
//     }

//     for (int i = 1; i <= 3; i++) {
//       await _notificationService.showNotification(
//         title: "Notification Multiple $i",
//         body: "Message de test numéro $i",
//         payload: "multiple_test_$i",
//         playSound: _playSound,
//         enableVibration: _enableVibration,
//       );
//       await Future.delayed(Duration(milliseconds: 500));
//     }
    
//     _showSnackBar("3 notifications envoyées", Colors.green);
//   }

//   Future<void> _cancelSpecificNotification() async {
//     if (_idController.text.isEmpty) {
//       _showSnackBar("Veuillez entrer un ID de notification", Colors.orange);
//       return;
//     }

//     try {
//       int id = int.parse(_idController.text);
//       await _notificationService.cancelNotification(id);
//       _showSnackBar("Notification $id annulée", Colors.blue);
//     } catch (e) {
//       _showSnackBar("ID invalide", Colors.red);
//     }
//   }

//   Future<void> _cancelAllNotifications() async {
//     await _notificationService.cancelAllNotifications();
//     _showSnackBar("Toutes les notifications annulées", Colors.blue);
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _bodyController.dispose();
//     _payloadController.dispose();
//     _idController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Test Notifications Flutter'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Indicateur d'état
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _isInitialized ? Colors.green.shade100 : Colors.red.shade100,
//                 border: Border.all(
//                   color: _isInitialized ? Colors.green : Colors.red,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _isInitialized ? Icons.check_circle : Icons.error,
//                     color: _isInitialized ? Colors.green : Colors.red,
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     _isInitialized 
//                         ? 'Service initialisé - Prêt pour les tests'
//                         : 'Initialisation en cours...',
//                     style: TextStyle(
//                       color: _isInitialized ? Colors.green.shade800 : Colors.red.shade800,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             SizedBox(height: 20),
            
//             // Configuration de la notification
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Configuration de la notification',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 16),
                    
//                     TextField(
//                       controller: _titleController,
//                       decoration: InputDecoration(
//                         labelText: 'Titre',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.title),
//                       ),
//                     ),
//                     SizedBox(height: 12),
                    
//                     TextField(
//                       controller: _bodyController,
//                       decoration: InputDecoration(
//                         labelText: 'Message',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.message),
//                       ),
//                       maxLines: 2,
//                     ),
//                     SizedBox(height: 12),
                    
//                     TextField(
//                       controller: _payloadController,
//                       decoration: InputDecoration(
//                         labelText: 'Payload (optionnel)',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.data_object),
//                       ),
//                     ),
//                     SizedBox(height: 16),
                    
//                     // Options
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CheckboxListTile(
//                             title: Text('Son'),
//                             value: _playSound,
//                             onChanged: (value) {
//                               setState(() {
//                                 _playSound = value ?? true;
//                               });
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: CheckboxListTile(
//                             title: Text('Vibration'),
//                             value: _enableVibration,
//                             onChanged: (value) {
//                               setState(() {
//                                 _enableVibration = value ?? true;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             SizedBox(height: 20),
            
//             // Boutons de test
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Tests de notifications',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 16),
                    
//                     ElevatedButton.icon(
//                       onPressed: _isInitialized ? _sendTestNotification : null,
//                       icon: Icon(Icons.send),
//                       label: Text('Envoyer notification personnalisée'),
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(double.infinity, 48),
//                       ),
//                     ),
//                     SizedBox(height: 12),
                    
//                     ElevatedButton.icon(
//                       onPressed: _isInitialized ? _sendMultipleNotifications : null,
//                       icon: Icon(Icons.send_and_archive),
//                       label: Text('Envoyer 3 notifications rapides'),
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(double.infinity, 48),
//                         backgroundColor: Colors.orange,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             SizedBox(height: 20),
            
//             // Gestion des notifications
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Gestion des notifications',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 16),
                    
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _idController,
//                             decoration: InputDecoration(
//                               labelText: 'ID à annuler',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.numbers),
//                             ),
//                             keyboardType: TextInputType.number,
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         ElevatedButton(
//                           onPressed: _cancelSpecificNotification,
//                           child: Text('Annuler'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12),
                    
//                     ElevatedButton.icon(
//                       onPressed: _cancelAllNotifications,
//                       icon: Icon(Icons.clear_all),
//                       label: Text('Annuler toutes les notifications'),
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(double.infinity, 48),
//                         backgroundColor: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             SizedBox(height: 20),
            
//             // Informations
//             Card(
//               color: Colors.blue.shade50,
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info, color: Colors.blue),
//                         SizedBox(width: 8),
//                         Text(
//                           'Informations de test',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue.shade800,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '• Tapez sur les notifications pour voir les logs dans la console\n'
//                       '• Les notifications utilisent un ID unique basé sur le timestamp\n'
//                       '• Testez les différentes options (son, vibration)\n'
//                       '• Vérifiez que les notifications apparaissent dans la barre de notification',
//                       style: TextStyle(color: Colors.blue.shade700),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
