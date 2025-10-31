import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier.dart'; // 로그아웃 처리를 위해 필요

class SettingsScreen extends ConsumerWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 테마 색상 제거하고 기본 Scaffold 색상 사용
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        // 색상 관련 설정 제거
      ),
      body: ListView(
        children: [
          // 1. 프로필 수정
          ListTile(
            title: const Text('프로필 수정'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: 프로필 수정 화면으로 이동
            },
          ),
          const Divider(),

          // 2. 화면 테마
          ListTile(
            title: const Text('화면 테마'),
            subtitle: const Text('현재 테마: 시스템 기본'), // 현재 상태 표시
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: 테마 변경 다이얼로그 또는 화면 띄우기
            },
          ),
          const Divider(),

          // 3. 문의하기 (Q&A)
          ListTile(
            title: const Text('Q&A / 문의하기'),
            trailing: const Icon(Icons.launch, size: 16),
            onTap: () {
              // TODO: 이메일 앱 실행 또는 문의 페이지로 이동
            },
          ),
          const Divider(),

          // 4. 로그아웃 (맨 아래 배치)
          ListTile(
            title: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // 로그아웃 로직 호출 및 화면 전환
              await ref.read(authNotifierProvider.notifier).logout();

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
