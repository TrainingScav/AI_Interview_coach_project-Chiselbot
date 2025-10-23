import 'package:flutter/material.dart';
import '../chat/chat_screen.dart';

class DebugHome extends StatelessWidget {
  const DebugHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            );
          },
          child: const Text('채팅 화면 열기'),
        ),
      ),
    );
  }
}
