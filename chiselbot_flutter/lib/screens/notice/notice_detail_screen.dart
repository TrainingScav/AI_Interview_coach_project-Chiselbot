import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/notice_provider.dart';

class NoticeDetailScreen extends ConsumerWidget {
  final int noticeId;

  const NoticeDetailScreen({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeProvider(noticeId));

    return Scaffold(
      appBar: AppBar(
          // title: const Text('공지사항'),
          // backgroundColor: Colors.orange.shade100,
          ),
      body: noticeAsync.when(
        data: (notice) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.shade200,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.campaign,
                      color: Colors.orange.shade700,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        notice.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 날짜
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    notice.date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // 내용
              Text(
                notice.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              // 목록으로 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.list),
                  label: const Text('목록으로'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    side: BorderSide(color: Colors.orange.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.orange),
                const SizedBox(height: 8),
                Text(
                  '공지사항을 불러올 수 없습니다',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('$e', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('목록으로'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
