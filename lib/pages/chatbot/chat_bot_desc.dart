import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/components/personalized_widget.dart';
import 'chat_screen_1.dart';

class ChatBotDesc extends StatelessWidget {
  const ChatBotDesc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23253C),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'M\'OI, Your AI Assistant !',
                style: TextStyle(
                  fontFamily: 'RammettoOne',
                  fontSize: 35,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Ask anything about workouts, healthy eating, recovery tips, or staying motivated — our smart AI chatbot is here 24/7 to guide you.',
                style: normalTextStyle(),
                textAlign: TextAlign.center,
              ),
              Image(
                image: AssetImage('images/chatbot/chatbot3.png'),
              ),
              GradientButton(
                title: 'Continue',
                icon: Icons.arrow_forward,
                maxWidth: 500,
                maxHeight: 50,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat_Screen_1(),
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