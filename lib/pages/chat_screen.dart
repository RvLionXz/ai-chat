import 'package:flutter/material.dart';
import '/services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _inputController = TextEditingController();
  List<Map<String, String>> _message = [];
  bool isLoading = false;

  Future<void> sistemMessage() async {
    
  }

  Future<void> _handleMessage() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _message.add({'role': 'user', 'content': 'input'});
      _inputController.clear();
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Column(children: [
          ],
        )));
  }
}
