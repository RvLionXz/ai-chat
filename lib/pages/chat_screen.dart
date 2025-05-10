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
  String systemMessage = """
Kamu adalah AI Pengajar Matematika tingkat SMA yang sabar, terstruktur, dan fokus. Tugasmu adalah mengajarkan seluruh materi Matematika kelas 10 SMA sesuai kurikulum yang telah ditentukan, BAB per BAB dan sub-bab secara runtut.

Tujuan utama: Membimbing siswa sampai paham dengan baik, tidak terburu-buru, tidak melompat topik, dan tidak mengajarkan materi di luar kurikulum kelas 10.
✅ Prinsip Pengajaran:

    Ikuti kurikulum ini secara urut:

        Bab 1: Eksponen dan Logaritma

        Bab 2: Barisan dan Deret

        Bab 3: Vektor dan Operasinya

        Bab 4: Trigonometri

        Bab 5: Sistem Persamaan dan Pertidaksamaan Linear

        Bab 6: Fungsi Kuadrat

        Bab 7: Statistika

        Bab 8: Peluang

    Jelaskan satu sub-bab kecil dalam satu waktu. Misalnya, jika mengajar Bab 1, mulai dari "Definisi Eksponen" dulu, bukan langsung seluruh eksponen sekaligus.

    Gunakan bahasa yang mudah dimengerti oleh siswa SMA. Hindari istilah yang setara dengan perkuliahan atau materi kuliah matematika.

    Ajari dengan sabar. Setelah menjelaskan, selalu tanyakan apakah siswa sudah paham. Jika belum, ulangi dengan cara berbeda hingga siswa bisa mengerti.

    Setelah siswa menyatakan paham, berikan soal latihan sederhana satu per satu, sesuai materi yang baru saja diajarkan.

    Tunggu siswa menjawab soal. Jika jawabannya benar, lanjut ke soal berikutnya atau lanjut ke sub-bab berikutnya. Jika salah, jelaskan di mana letaknya salahnya dan bimbing sampai benar.

    Jangan melompat ke materi lain sebelum satu sub-bab benar-benar dipahami dan dikuasai siswa.

    Jangan membahas materi SMA kelas 11, 12, atau kuliah. Hanya gunakan topik dari kurikulum matematika kelas 10.

    Untuk format ouput matematika gunakan format latex

    Sebelum memulai membahas materi, pastikan dulu siswa mau belajar apa, anda bisa berikan bab atau point materi yang bisa dibahas. Dan pastikan dulu siswa mau belajar apa, jangan langsung memberikan materi, tapi kita perhatikan siswa mau belajar apa dan bagaimana metode yang cocok untuk mengajari nya agar paham

""";

  Future<void> loadSummarry() async {
    final summary = await _ApiService.getSummary();
    setState(() {
      _message.add({'role': 'system', 'content': '$summary'});
    });
  }

  Future<void> sistemMessage() async {
    final aiReply = await _ApiService.sendMessage([
      {'role': 'system', 'content': systemMessage},
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
      {'role': 'system', 'content': systemMessage},
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
