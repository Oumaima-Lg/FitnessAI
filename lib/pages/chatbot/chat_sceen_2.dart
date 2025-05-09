import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/pages/chatbot/chat_service.dart';
import 'package:flutter/material.dart';

class Chat_Screen_2 extends StatefulWidget {
  const Chat_Screen_2({super.key});

  @override
  State<Chat_Screen_2> createState() => _Chat_Screen_2State();
}

class _Chat_Screen_2State extends State<Chat_Screen_2> {
  final TextEditingController _controller = TextEditingController();
  final List<String> messages = [];

  final ChatService chatService = ChatService("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");

  void sendMessage() async {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add("You: $userInput");
    });

    _controller.clear();

    try {
      String reply = await chatService.sendMessage(userInput);
      setState(() {
        messages.add("Bot: $reply");
      });
    } catch (e) {
      setState(() {
        messages.add("Error: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23253C),
      appBar: ChatBotAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message.startsWith("You:");
                  final displayText = message.replaceFirst("You: ", "").replaceFirst("Bot: ", "");

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: isUser ? Radius.circular(0) : Radius.circular(20),
                                  bottomLeft: isUser ? Radius.circular(20) : Radius.circular(0),
                                ),
                              ),
                              child: Text(
                                displayText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),

                          if (!isUser)
                            Positioned(
                              bottom: -20,
                              left: -14,
                              child: Image.asset(
                                'images/chatbot/icon_bot.png',
                                width: 28,
                                height: 28,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Write your message',
                        hintStyle: TextStyle(
                          color: Color(0xFF23253C),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Color(0xFF23253C), fontWeight: FontWeight.w600),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.send,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
