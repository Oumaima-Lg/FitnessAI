import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/chatbot/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Chat_Screen_2 extends StatefulWidget {
  const Chat_Screen_2({super.key, this.initialMssg});

  final String? initialMssg;

  @override
  State<Chat_Screen_2> createState() => _Chat_Screen_2State();
}

class _Chat_Screen_2State extends State<Chat_Screen_2> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _lastMessageKey = GlobalKey();
  final List<String> messages = [];
  bool _isLoading = false;
  
  final ChatService chatService = ChatService("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");

  @override
  void initState(){
    super.initState();
    if(widget.initialMssg != null && widget.initialMssg!.isNotEmpty){
      
      setState(() {
        messages.add("You: ${widget.initialMssg!}");
        _isLoading = true;
      });
      _scrollToLastMessage();
      
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        try{
          String reply = await chatService.sendMessage(widget.initialMssg!);
          setState(() {
            messages.add("Bot: $reply");
            _isLoading = false;
          });
          _scrollToLastMessage();
        }catch(e){
          setState(() {
            messages.add("Error: $e");
            _isLoading = false;
          });
          _scrollToLastMessage();
        }
      });
    }
  }

  void sendMessage() async {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add("You: $userInput");
      _isLoading = true;
    });

    _controller.clear();
    _scrollToLastMessage();

    try {
      String reply = await chatService.sendMessage(userInput);
      setState(() {
        messages.add("Bot: $reply");
        _isLoading = false;
      });
      _scrollToLastMessage();
    } catch (e) {
      setState(() {
        messages.add("Error: $e");
        _isLoading = false;
      });
      _scrollToLastMessage();
    }
  }

  void _scrollToLastMessage() {
    Future.delayed(Duration(milliseconds: 100), () {
      final context = _lastMessageKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 300),
          alignment: 0.0,
          curve: Curves.easeInOut,
        );
      }
    });
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
                clipBehavior: Clip.none,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message.startsWith("You:");
                  final displayText = message.replaceFirst("You: ", "").replaceFirst("Bot: ", "");
                  final isLastMessage = index == messages.length - 1;

                  return Container(
                    key: isLastMessage ? _lastMessageKey : null,
                    child: Align(
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
                                child: MarkdownBody(
                                  data: displayText,
                                  styleSheet: MarkdownStyleSheet(
                                    p: normalTextStyle(fontSize: 16),
                                    strong: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            if (!isUser)
                              Positioned(
                                bottom: -13,
                                left: -14,
                                child: Image.asset('images/chatbot/icon_bot.png', width: 28, height: 28, ),
                              ),
                          ],
                        ),
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
                      onSubmitted: (value) => sendMessage(),
                      style: TextStyle(color: Color(0xFF23253C), fontWeight: FontWeight.w600),
                    ),
                  ),
                  _isLoading 
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                    : MouseRegion(
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
