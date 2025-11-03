// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/chat_message.dart';
// import '../strategies/next_question_strategy.dart';
//
// // 1) 전략 Provider
// final nextQuestionStrategyProvider = Provider<NextQuestionStrategy>(
//   (ref) => ScriptedNextQuestion(), // 추후 ApiNextQuestionStrategy 로 교체 가능
// );
//
// // 2) ChatMessagesNotifier 에 전략을 주입
// final chatMessagesProvider =
//     StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
//   final strategy = ref.watch(nextQuestionStrategyProvider);
//   return ChatMessagesNotifier(strategy)..startFirstQuestion();
// });
//
// class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
//   final NextQuestionStrategy _strategy;
//   ChatMessagesNotifier(this._strategy) : super(const []);
//
//   // 데모용 첫 질문
//   void startFirstQuestion() {
//     askTyping(
//       segments: const ['자기소개를 1분 이내로 해주세요.'],
//       finalText: '자기소개를 1분 이내로 해주세요.',
//     );
//   }
//
//   // 사용자 답변 추가
//   void addUser(String text) {
//     state = [...state, ChatMessage.user(text)];
//   }
//
//   // AI 질문(타자효과) 추가
//   void askTyping({required List<String> segments, required String finalText}) {
//     state = [
//       ...state,
//       ChatMessage.aiTyping(segments: segments, text: finalText),
//     ];
//   }
//
//   void finalizeTyping(int index) {
//     final msg = state[index];
//     if (msg.kind != MessageKind.aiTyping) return;
//     final newList = [...state];
//     newList[index] = ChatMessage.aiText(msg.text);
//     state = newList;
//   }
//
//   // 전략을 사용해 "다음 질문" 생성
//   void askNextByStrategy() {
//     askTyping(
//       segments: _strategy.segments(),
//       finalText: _strategy.finalText(),
//     );
//   }
// }
