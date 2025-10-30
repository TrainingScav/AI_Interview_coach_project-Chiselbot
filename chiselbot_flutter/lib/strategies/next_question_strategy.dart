// 교체 가능한 "다음 질문 생성 규칙" 전략 인터페이스
abstract class NextQuestionStrategy {
  List<String> segments();
  String finalText();
}

// 기본 스크립트형(지금 범위: 질문 1개 → 피드백)
class ScriptedNextQuestion implements NextQuestionStrategy {
  @override
  List<String> segments() => const [
        '좋습니다. 다음 질문입니다.',
        '최근에 해결했던 기술적 문제 하나를 설명해 주세요.',
      ];

  @override
  String finalText() => '좋습니다. 다음 질문입니다.\n최근에 해결했던 기술적 문제 하나를 설명해 주세요.';
}
