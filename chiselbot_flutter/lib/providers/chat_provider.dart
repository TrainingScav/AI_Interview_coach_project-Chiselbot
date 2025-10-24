import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';

// 면접 채팅의 상태머신

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
  (ref) => ChatMessagesNotifier()..startFirstQuestion(),
);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super(const []);

  // 데모용 첫 질문
  void startFirstQuestion() {
    askTyping(
      segments: const ['자기소개를 1분 이내로 해주세요.'],
      finalText: '자기소개를 1분 이내로 해주세요.',
    );
  }

  // 사용자 답변 추가
  void addUser(String text) {
    state = [...state, ChatMessage.user(text)];
  }

  // AI 질문(타자효과) 추가
  void askTyping({required List<String> segments, required String finalText}) {
    state = [
      ...state,
      ChatMessage.aiTyping(segments: segments, text: finalText),
    ];
  }

  void finalizeTyping(int index) {
    final msg = state[index];
    if (msg.kind != MessageKind.aiTyping) return;
    final newList = [...state];
    newList[index] = ChatMessage.aiText(msg.text);
    state = newList;
  }

  // 데모용: 다음 질문 세그먼트
  List<String> buildNextQuestionSegments() => const [
        '좋습니다. 두 번째 질문입니다.',
        '최근에 해결했던 기술적 문제 하나를 설명해 주세요.',
      ];
  String buildNextQuestionFinal() =>
      '좋습니다. 두 번째 질문입니다.\n최근에 해결했던 기술적 문제 하나를 설명해 주세요.';
}
