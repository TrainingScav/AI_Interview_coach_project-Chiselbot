enum MessageKind { user, aiText, aiTyping }

class ChatMessage {
  final MessageKind kind;
  final String text; // aiTyping에서도 “완료 후 남길 문장(text)”으로 사용
  final List<String>? segments; // aiTyping일 때만 사용(타이핑용 문장 리스트)

  const ChatMessage.user(this.text)
      : kind = MessageKind.user,
        segments = null;

  const ChatMessage.aiText(this.text)
      : kind = MessageKind.aiText,
        segments = null;

  const ChatMessage.aiTyping({required this.segments, required this.text})
      : kind = MessageKind.aiTyping;
}
