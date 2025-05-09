import 'dart:convert';
import 'package:http/http.dart' as http;

/// This class handles communication with the GitHub-hosted GPT model.
class ChatService {
  static const String _endpoint = 'https://models.github.ai/inference/chat/completions';
  static const String _model = 'openai/gpt-4.1';

  /// Replace this with secure storage in production!
  final String token;

  ChatService(this.token);

  Future<String> sendMessage(String userMessage) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "messages": [
          {"role": "system", "content": ""},
          {"role": "user", "content": userMessage}
        ],
        "temperature": 1,
        "top_p": 1,
        "model": _model,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
