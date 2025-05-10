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
  final _ApiService = ApiService();
  bool isLoading = false;

  Future<void> loadSummarry() async {
    final summary = await _ApiService.getSummary();
    setState(() {
      _message.add({
        'role': 'system',
        'content': '$summary'
      });
    });
  }

  Future<void> sistemMessage() async {
    final aiReply = await _ApiService.sendMessage([
      {
        'role': 'system',
        'content':
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
    ]);

    setState(() {
      _message.add({'role': 'assistant', 'content': aiReply});
    });
  }

  Future<void> _handleMessage() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _message.add({'role': 'user', 'content': input});
      _inputController.clear();
      isLoading = true;
    });

    final aiReply = await _ApiService.sendMessage([
      {
        'role': 'system',
        'content':
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
      ..._message,
    ]);

    // Ringkas Chat
    final summary = await _ApiService.summarizeConversation([..._message]);
    await _ApiService.saveSummary(summary);

    setState(() {
      _message.add({'role': 'system', 'content': summary});
      _message.add({'role': 'assistant', 'content': aiReply});
      isLoading = false;
    });
  }

  Widget _buildMessage(Map<String, String> msg) {
    if (msg['role'] == 'system') return const SizedBox();
    return Align(
      alignment:
          msg['role'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg['role'] == 'user' ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg['content'] ?? "",
          style: TextStyle(
            color: msg['role'] == 'user' ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSummarry();
    sistemMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Ai Chat App")),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _message.length,
                itemBuilder: (context, index) => _buildMessage(_message[index]),
              ),
            ),
            if (isLoading) const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: "Ketik Pesan..",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: isLoading ? null : _handleMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
