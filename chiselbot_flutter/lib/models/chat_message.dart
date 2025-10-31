enum MessageKind { user, aiText, aiTyping }

class ChatMessage {
  final MessageKind kind; // 메시지의 종류 (위의 enum 참고)
  final String text; // 메시지의 실제 텍스트 (완성된 문장)
  final List<String>? segments; // 애니메이션용 텍스트

  const ChatMessage.user(this.text)
      : kind = MessageKind.user,
        segments = null;

  const ChatMessage.aiText(this.text)
      : kind = MessageKind.aiText,
        segments = null;

  const ChatMessage.aiTyping({required this.segments, required this.text})
      : kind = MessageKind.aiTyping;
}
