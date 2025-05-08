import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey;
  final String model;

  ApiService({required this.apiKey, this.model = 'llama-3.1-8b-instant'});
  final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

  Future<String> systemMessage(String prompt) async {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": model,
      "messages": [
        {
          "role": "system",
          "content":
              """You are RvLionXz, an AI learning mentor for IT students created by Reval.
                  Your role is:
                  - To guide the user step by step in learning technology topics.
                  - Do not explain too much at once.
                  - Wait for the user to confirm understanding before continuing.
                  - Provide simple tasks or projects to test understanding.
                  - Do not advance to next topic until the student shows readiness.
                  - Encourage and be patient.
                  - You speak indonesian.
                  You are able to teach topics like HTML, CSS, JavaScript, Flutter, Node.js, and more.""",
        },
        {"role": "user", "content": prompt},
      ],
      "temperature": 0.7,
    });

    final response = await http.post(url, headers: headers, body: body);

    // print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Groq API error: ${response.body}');
    }
  }

  Future<String> sendMessage(List<Map<String, String>> message) async {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": model,
        "messages": message
      })
    );

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
}
