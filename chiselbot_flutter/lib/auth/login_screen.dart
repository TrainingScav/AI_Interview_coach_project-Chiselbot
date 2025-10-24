/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';
import 'auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _id = TextEditingController();
  final _pw = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _id.dispose();
    _pw.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      // TODO: 실제 구현 주입 시 Provider로 가져오기
      final repo = AuthRepositoryImpl();
      final tokens = await repo.login(id: _id.text.trim(), pw: _pw.text.trim());
      await ref
          .read(authStateProvider.notifier)
          .setTokens(access: tokens.access, refresh: tokens.refresh);
    } catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('로그인 실패')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
              controller: _id,
              decoration: const InputDecoration(labelText: '아이디')),
          const SizedBox(height: 12),
          TextField(
              controller: _pw,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호')),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _loading ? null : _login,
            child: _loading
                ? const CircularProgressIndicator()
                : const Text('로그인'),
          ),
        ]),
      ),
    );
  }
}
*/
