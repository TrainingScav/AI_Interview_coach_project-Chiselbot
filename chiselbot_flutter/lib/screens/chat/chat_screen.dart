import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';

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
                      onPressed: () {
                        setState(() => _awaitingNext = false);
                        final n = ref.read(chatMessagesProvider.notifier);
                        n.askNextByStrategy(); // 전략 패턴 적용된 다음 질문
                        _focusNode.requestFocus();
                        _scrollToBottom();
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

    // 1. 내 답변 추가
    ref.read(chatMessagesProvider.notifier).addUser(text);
    _controller.clear();
    _scrollToBottom();

    // 2. 피드백 세그먼트 (임시 또는 서버 응답)
    final feedbackSegments = const [
      '좋아요. 핵심 개념은 잘 짚었습니다.',
      '조금 더 구체적 예시를 들면 완성도가 올라가요.'
    ];

    // 3. 피드백 출력
    _isFeedbackPhase = true;
    ref.read(chatMessagesProvider.notifier).askTyping(
          segments: feedbackSegments,
          finalText: feedbackSegments.join('\n'),
        );
    _scrollToBottom();
    FocusScope.of(context).unfocus(); // 입력창 닫기
  }
}
