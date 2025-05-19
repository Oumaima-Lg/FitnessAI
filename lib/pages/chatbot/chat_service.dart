import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _endpoint = 'https://models.github.ai/inference/chat/completions';  // URL de l'API à laquelle on va envoyer un msg
  static const String _model = 'openai/gpt-4.1'; // le modèle li st3mlna

  final String token;

  ChatService(this.token);

  Future<String> sendMessage(String userMessage) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json', // => hna format des données
        'Authorization': 'Bearer $token', // => sécurité =>  Il sert à authentifier la requête : l’API vérifie que tu es bien autorisé à utiliser le service
      },
      body: jsonEncode({
        "messages": [ // le format utilisé par ChatGPT (chat multi-tour) 
          {"role": "system", "content": "You are a motivating fitness coach, expert in training, nutrition, and wellness. Give clear advice, tailored to the user's level, and always stay positive."},
          {"role": "user", "content": userMessage}
        ],
        "temperature": 1, // contrôle de la créativité
        "top_p": 1, // 
        "model": _model,
      }),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); 
      final data = jsonDecode(decodedBody);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
