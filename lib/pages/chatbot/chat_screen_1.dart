import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'chat_sceen_2.dart';
import 'package:fitness/models/statique_qsts.dart';
import 'package:flutter/material.dart';

class Chat_Screen_1 extends StatelessWidget {
  const Chat_Screen_1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23253C),
      appBar: ChatBotAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: lesQuestions.length,
                  itemBuilder: (context, index) {
                    final group = lesQuestions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                group.icon,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                group.title,
                                style: normalTextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        ...group.qsts.map((q) => ButtonQuestion(qst: q, maxHeight: 50, maxWidth: 500,)).toList(),
                        SizedBox(height: 18),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => Chat_Screen_2(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      Text(
                        'Hello M’OI, How are you ?',
                        style: titleTextStyle(color: Color(0xFF23253C), fontWeight: FontWeight.w600, fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white, 
                          size: 24,
                        ),
                      ),
                    ],
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

class ButtonQuestion extends StatelessWidget {
  final String qst;
  final double maxWidth;
  final double maxHeight;

  const ButtonQuestion({
    super.key,
    required this.qst,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: maxWidth,
          height: maxHeight,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  qst,
                  style: normalTextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}