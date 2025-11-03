import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/main_appbar.dart';
import '../widgets/main_drawer.dart';
import '../widgets/main_view.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const MainAppbar(),
        drawer: const MainDrawer(),
        body: const MainView(),
      ),
    );
  }
}
