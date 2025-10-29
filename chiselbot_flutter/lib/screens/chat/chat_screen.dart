import 'package:flutter/material.dart';
import '../../providers/app_providers.dart';
import '../../providers/qna_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  late QnaProvider qna;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    qna = AppProviders.of(context).qna;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 면접 코치')),
      body: AnimatedBuilder(
        animation: qna,
        builder: (context, _) {
          if (qna.currentQuestion == null) {
            return const Center(child: Text('질문이 없습니다. 메인에서 시작하세요.'));
          }
          final q = qna.currentQuestion!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('[${q.categoryName}] ${q.questionText}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 12),
                TextField(
                  controller: _ctrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: '답변을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: qna.loading
                          ? null
                          : () async {
                              await qna.submitAnswer(_ctrl.text.trim());
                              if (qna.error != null && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('코칭 실패: ${qna.error}')),
                                );
                              }
                            },
                      child: qna.loading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('코칭 받기'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (qna.lastFeedback != null) ...[
                  const Divider(),
                  Text('피드백: ${qna.lastFeedback!.feedback}'),
                  if (qna.lastFeedback!.hint != null &&
                      qna.lastFeedback!.hint!.isNotEmpty)
                    Text('힌트: ${qna.lastFeedback!.hint}'),
                  Text(
                      '유사도: ${qna.lastFeedback!.similarity.toStringAsFixed(2)}'),
                  if (qna.lastFeedback!.questionAnswer != null)
                    Text('모범답안(요약): ${qna.lastFeedback!.questionAnswer}'),
                ],
                if (qna.error != null)
                  Text('에러: ${qna.error}',
                      style: const TextStyle(color: Colors.red)),
              ],
            ),
          );
        },
      ),
    );
  }
}
