import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: Colors.grey[900],
      width: screenWidth * .85,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              '개발자',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'test1@naver.com',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade800, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('프로필'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: 프로필 화면 이동
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('면접 보관함'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: 기록 화면 이동
                  },
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade800, indent: 16, endIndent: 16),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title:
                        const Text('로그아웃', style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      // 로그아웃 처리
                      await ref.read(authNotifierProvider.notifier).logout();

                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(
                        '/settings',
                      );
                    },
                    child: const Icon(Icons.settings),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
