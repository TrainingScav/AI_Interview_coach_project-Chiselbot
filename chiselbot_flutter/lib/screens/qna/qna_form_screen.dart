import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/qna_provider.dart';

class QnaFormScreen extends ConsumerStatefulWidget {
  const QnaFormScreen({super.key});

  @override
  ConsumerState<QnaFormScreen> createState() => _QnaFormScreenState();
}

class _QnaFormScreenState extends ConsumerState<QnaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(createInquiryProvider.notifier).submit(
        title: _titleCtrl.text.trim(), content: _contentCtrl.text.trim());
    final state = ref.read(createInquiryProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록 실패: ${state.error}')),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('문의가 등록되었습니다.')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(createInquiryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('문의 작성')),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '제목을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextFormField(
                  controller: _contentCtrl,
                  decoration: const InputDecoration(labelText: '내용'),
                  maxLines: null,
                  expands: true,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '내용을 입력하세요' : null,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: async.isLoading
                      ? const Text('전송 중...')
                      : const Text('등록'),
                  onPressed: async.isLoading ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
