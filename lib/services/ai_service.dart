import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String apiKey =
      "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";
  final String model = "llama-3.1-8b-instant";
  final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");
  static const _summaryKey = 'chat_summary';

  Future<String> sendMessage(List<Map<String, String>> message) async {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"model": model, "messages": message}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      throw (response.statusCode);
    }
    return data['choices'][0]['message']['content'];
  }

  // save message history
  Future<void> saveSummary(String summary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_summaryKey, summary);
    // print("SUMMARY SAVE : ${summary}");
  }

  // get message history
  Future<String?> getSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final summary = prefs.getString(_summaryKey);
    // print("SUMMARY RETRIEVED: $summary");
    return summary;
  }

  // Suummarize message
  Future<String> summarizeConversation(
    List<Map<String, String>> message,
  ) async {
    final summarizedMessages = [
      ...message,
      {
        "role": "user",
        "content": "Ringkas seluruh percakapan ini dalam satu paragraf.",
      },
    ];

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama3-8b-8192",
        "messages": summarizedMessages,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(data['choices'][0]['message']['content']);
      saveSummary(data['choices'][0]['message']['content']);
    }
    return data['choices'][0]['message']['content'];
  }
}
