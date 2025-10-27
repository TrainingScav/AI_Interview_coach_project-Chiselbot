import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';

import '../../providers/app_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();

  bool _isFeedbackPhase = false; // 피드백 중인지
  bool _awaitingNext = false; // 다음 질문 대기 중인지

  // 현재 질문 ID를 로컬로 보관 (postAnswer에 필요)
  int? _currentQuestionId;

  @override
  void initState() {
    super.initState();

    // 화면 진입 시 "실제 질문" 불러와서 첫 메시지로 출력
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // 카테고리가 아직 선택되지 않았다면 기본값(1: 기술) 지정
        final cat = ref.read(selectedCategoryIdProvider);
        if (cat == null) {
          ref.read(selectedCategoryIdProvider.notifier).state = 1;
        }

        final q = await ref.read(oneQuestionProvider.future);
        _currentQuestionId = q.id;

        ref.read(chatMessagesProvider.notifier).askTyping(
          segments: [q.questionText],
          finalText: q.questionText,
        );
        _scrollToBottom(instant: true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('문제 불러오기 실패: $e')),
          );
        }
      }
    });
  }

  void _scrollToBottom({bool instant = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      final max = _scrollCtrl.position.maxScrollExtent;
      if (instant) {
        _scrollCtrl.jumpTo(max);
      } else {
        _scrollCtrl.animateTo(
          max,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((r) => r.isFirst);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text('AI 면접 코치')),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    switch (m.kind) {
                      case MessageKind.user:
                        return MessageBubble(isUser: true, text: m.text);
                      case MessageKind.aiText:
                        return MessageBubble(isUser: false, text: m.text);
                      case MessageKind.aiTyping:
                        return MessageBubble(
                          isUser: false,
                          animatedSegments: m.segments!,
                          onCompleted: () {
                            ref
                                .read(chatMessagesProvider.notifier)
                                .finalizeTyping(i);
                            _scrollToBottom();
                            _scrollToBottom();

                            // 피드백 끝났으면 “다음 질문” 버튼 준비
                            if (_isFeedbackPhase && i == messages.length - 1) {
                              setState(() {
                                _isFeedbackPhase = false;
                                _awaitingNext = true;
                              });
                            }
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 120),
          padding: EdgeInsets.only(
            left: 10,
            right: 6,
            top: 6,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            bottom: false,
            child: _awaitingNext
                // ▶ 피드백 끝난 상태: “다음 질문” 버튼 표시
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.skip_next),
                      label: const Text('다음 질문'),
                      onPressed: () async {
                        setState(() => _awaitingNext = false);

                        try {
                          // 카테고리가 비어 있으면 기본값(1) 보정
                          final cat = ref.read(selectedCategoryIdProvider);
                          if (cat == null) {
                            ref
                                .read(selectedCategoryIdProvider.notifier)
                                .state = 1;
                          }

                          final q = await ref.read(oneQuestionProvider.future);
                          _currentQuestionId = q.id;

                          ref.read(chatMessagesProvider.notifier).askTyping(
                            segments: [q.questionText],
                            finalText: q.questionText,
                          );
                          _focusNode.requestFocus();
                          _scrollToBottom();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('다음 질문 불러오기 실패: $e')),
                            );
                          }
                        }
                      },
                    ),
                  )
                // 평소 상태: 입력창 + 전송 버튼
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          decoration: const InputDecoration(
                            hintText: '답변을 입력하세요…',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                          onSubmitted: _onSend,
                          onTap: () {
                            _scrollToBottom();
                            Future.delayed(const Duration(milliseconds: 20),
                                _scrollToBottom);
                          },
                          scrollPadding: const EdgeInsets.only(bottom: 120),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _onSend(_controller.text),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _onSend(String value) async {
    final text = value.trim();
    if (text.isEmpty) return;

    // 1) 내 답변 추가
    ref.read(chatMessagesProvider.notifier).addUser(text);
    _controller.clear();
    _scrollToBottom();

    // 현재 질문이 있어야 피드백 가능
    if (_currentQuestionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('현재 질문이 없습니다. 다시 시도해 주세요.')),
      );
      return;
    }

    // 2) 서버/Mock에 피드백 요청
    try {
      _isFeedbackPhase = true;

      final api = ref.read(apiProvider);
      final resp = await api.postAnswer(
        questionId: _currentQuestionId!,
        answerText: text,
      );

      // 3) 피드백 말풍선(타자 효과) 출력
      final segs = resp.segments;
      ref.read(chatMessagesProvider.notifier).askTyping(
            segments: segs,
            finalText: segs.join('\n'),
          );
      _scrollToBottom();
      FocusScope.of(context).unfocus(); // 입력창 닫기
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('피드백 요청 실패: $e')),
        );
      }
    }
  }
}
