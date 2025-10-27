import 'dart:async';
import '../models/api_models.dart';
import 'api_service.dart';

/// ApiService를 상속해 동일한 메서드 시그니처로 동작하는 Mock
class MockApiService extends ApiService {
  MockApiService() : super('mock');

  final _nowIso = DateTime.now().toUtc().toIso8601String();

  final _categories = [
    InterviewCategory(id: 1, name: '기술'),
    InterviewCategory(id: 2, name: '인성'),
    InterviewCategory(id: 3, name: '경험'),
  ];

  final Map<String, List<InterviewQuestion>> _pool = {
    '1-1': [
      InterviewQuestion(
        id: 101,
        categoryId: 1,
        levelId: 1,
        questionText: 'HTTP와 HTTPS의 차이를 설명하세요.',
        intentText: '보안/암호화 개념 파악',
        createdAt: null,
      ),
    ],
    '1-2': [
      InterviewQuestion(
        id: 102,
        categoryId: 1,
        levelId: 2,
        questionText: 'GC가 동작하는 원리를 간단히 설명해 보세요.',
        intentText: '메모리 관리 이해',
        createdAt: null,
      ),
    ],
    '1-3': [
      InterviewQuestion(
        id: 103,
        categoryId: 1,
        levelId: 3,
        questionText: '최근 해결한 까다로운 버그를 구조적으로 설명해 보세요.',
        intentText: '문제 해결/사고력',
        createdAt: null,
      ),
    ],
    '2-1': [
      InterviewQuestion(
        id: 201,
        categoryId: 2,
        levelId: 1,
        questionText: '본인의 강점 1가지를 말해보세요.',
        intentText: '자기이해/핵심 요약',
        createdAt: null,
      ),
    ],
    '3-2': [
      InterviewQuestion(
        id: 302,
        categoryId: 3,
        levelId: 2,
        questionText: '팀 프로젝트에서 맡았던 역할과 기여를 설명해 보세요.',
        intentText: '협업/책임',
        createdAt: null,
      ),
    ],
    '1-null': [
      InterviewQuestion(
        id: 150,
        categoryId: 1,
        levelId: null,
        questionText: 'OOP 4대 특성을 간단히 설명해 보세요.',
        intentText: '기초 지식',
        createdAt: null,
      ),
    ],
  };

  @override
  Future<List<InterviewCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _categories;
  }

  @override
  Future<InterviewQuestion> fetchOneQuestion(
      {required int categoryId, int? levelId}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final key = '$categoryId-${levelId?.toString() ?? "null"}';
    final fallbackKey = '$categoryId-null';
    final list = _pool[key] ?? _pool[fallbackKey];
    if (list == null || list.isEmpty) {
      return InterviewQuestion(
        id: 999,
        categoryId: categoryId,
        levelId: levelId,
        questionText: '샘플 질문이 없습니다. 카테고리/레벨 구성을 늘려보세요.',
        intentText: '샘플 가이드',
        createdAt: DateTime.tryParse(_nowIso),
      );
    }
    final q = list.first;
    return InterviewQuestion(
      id: q.id,
      categoryId: q.categoryId,
      levelId: q.levelId,
      questionText: q.questionText,
      intentText: q.intentText,
      createdAt: DateTime.tryParse(_nowIso),
    );
  }

  @override
  Future<FeedbackResponse> postAnswer({
    required int questionId,
    required String answerText,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final length = answerText.trim().length;
    final score = (60 + (length / 10)).clamp(60, 95).toInt();
    final segments = <String>[
      if (length < 30) '핵심이 조금 부족해요. 핵심 키워드를 먼저 말해보면 좋아요.' else '핵심을 잘 짚었습니다.',
      '상황-과제-행동-결과(STAR) 구조로 정리하면 더 명확해져요.',
    ];
    final levelName = score >= 85
        ? '응용·사고형'
        : score >= 70
            ? '이해형'
            : '지식형';
    final pointTags = ['구조화', '명확성', '예시'];

    return FeedbackResponse(
      segments: segments,
      score: score,
      levelName: levelName,
      pointTags: pointTags,
    );
  }
}
