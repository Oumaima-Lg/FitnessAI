import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/pages/chatbot/chat_bot_desc.dart';
import 'package:flutter/material.dart';

class ChatBotWelcome extends StatelessWidget {
  const ChatBotWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23253C),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/chatbot/chatbot1.png'),
              ),
              Text(
                'Welcome To M\'OI',
                style: TextStyle(
                  fontFamily: 'RammettoOne',
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20,),
              GradientButton(
                title: 'Next',
                icon: Icons.arrow_forward,
                maxWidth: 500,
                maxHeight: 50,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatBotDesc(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}