import 'package:ai_interview/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/main_view.dart';
import 'package:ai_interview/screens/chat/chat_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MainAppbar(),
      body: const MainView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('면접 시작'),
      ),
    );
  }
}
