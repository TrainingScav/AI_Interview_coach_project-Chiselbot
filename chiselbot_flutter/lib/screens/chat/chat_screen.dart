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

    return Scaffold(
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
          child: Row(
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  onSubmitted: _onSend,
                  onTap: () {
                    _scrollToBottom();
                    Future.delayed(
                        const Duration(milliseconds: 20), _scrollToBottom);
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
    );
  }

  void _onSend(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    // 사용자 답변 추가
    ref.read(chatMessagesProvider.notifier).addUser(text);

    // 입력창 정리 + 스크롤
    _controller.clear();
    _scrollToBottom();

    // 다음 질문(타자효과) 바로 이어서 추가
    final n = ref.read(chatMessagesProvider.notifier);
    n.askTyping(
      segments: n.buildNextQuestionSegments(),
      finalText: n.buildNextQuestionFinal(),
    );

    // 포커스 유지(계속 답변 치기 좋게)
    _focusNode.requestFocus();
    _scrollToBottom();
  }
}
