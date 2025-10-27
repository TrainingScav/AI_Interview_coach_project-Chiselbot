// lib/screens/qna/qna_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/qna_provider.dart';
import '../../models/inquiry.dart';

class QnaDetailScreen extends ConsumerStatefulWidget {
  final int inquiryId;
  const QnaDetailScreen({super.key, required this.inquiryId});

  @override
  ConsumerState<QnaDetailScreen> createState() => _QnaDetailScreenState();
}

class _QnaDetailScreenState extends ConsumerState<QnaDetailScreen> {
  final _answerCtrl = TextEditingController();

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(inquiryDetailProvider(widget.inquiryId));
    final isAdmin = ref.watch(currentAdminIdProvider) != null;

    return Scaffold(
      appBar: AppBar(title: const Text('문의 상세')),
      body: detailAsync.when(
        data: (inq) {
          final canAnswer = isAdmin &&
              inq.status == InquiryStatus.WAITING &&
              (inq.answerContent == null || inq.answerContent!.isEmpty);
          return Padding(
            padding: const EdgeInsets.all(14),
            child: ListView(
              children: [
                Text(inq.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                    '작성일: ${inq.createdAt.year}-${inq.createdAt.month.toString().padLeft(2, '0')}-${inq.createdAt.day.toString().padLeft(2, '0')}  (ID: ${inq.inquiryId})'),
                const SizedBox(height: 14),
                const Text('문의 내용',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(inq.content),
                const Divider(height: 32),
                const Text('관리자 답변',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                if (inq.answerContent != null && inq.answerContent!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(inq.answerContent!),
                  )
                else
                  Text(
                    '아직 답변이 없습니다.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                const SizedBox(height: 16),
                if (canAnswer) _buildAnswerBox(context, inq),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
    );
  }

  Widget _buildAnswerBox(BuildContext context, Inquiry inq) {
    final answerAsync = ref.watch(answerInquiryProvider);

    Future<void> submit() async {
      final txt = _answerCtrl.text.trim();
      if (txt.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('답변을 입력하세요')));
        return;
      }
      await ref
          .read(answerInquiryProvider.notifier)
          .submit(inquiryId: inq.inquiryId, answer: txt);
      final st = ref.read(answerInquiryProvider);
      if (st.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('등록 실패: ${st.error}')));
      } else {
        _answerCtrl.clear();
        // 상세/목록 갱신
        ref.invalidate(inquiryDetailProvider(inq.inquiryId));
        ref.invalidate(inquiriesProvider);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('답변이 등록되었습니다.')));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _answerCtrl,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: '관리자 답변 (1회)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.reply),
          label: answerAsync.isLoading
              ? const Text('등록 중...')
              : const Text('답변 등록'),
          onPressed: answerAsync.isLoading ? null : submit,
        ),
      ],
    );
  }
}
