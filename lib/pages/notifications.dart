
import 'package:flutter/material.dart';
import '../components/textStyle/textstyle.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
            'Notifications',
          style: titleTextStyle(),
        ),
      ),
    );
  }
}