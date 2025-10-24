class InterviewCategory {
  final int id;
  final String name;
  InterviewCategory({required this.id, required this.name});
  factory InterviewCategory.fromJson(Map<String, dynamic> j) =>
      InterviewCategory(id: j['id'], name: j['name']);
}

class InterviewQuestion {
  final int id;
  final int categoryId;
  final int? levelId;
  final String questionText;
  final String? intentText;
  final DateTime? createdAt;

  InterviewQuestion({
    required this.id,
    required this.categoryId,
    this.levelId,
    required this.questionText,
    this.intentText,
    this.createdAt,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> j) =>
      InterviewQuestion(
        id: j['id'],
        categoryId: j['categoryId'],
        levelId: j['levelId'],
        questionText: j['questionText'],
        intentText: j['intentText'],
        createdAt:
            j['createdAt'] != null ? DateTime.parse(j['createdAt']) : null,
      );
}

class FeedbackResponse {
  final List<String> segments;
  final int? score;
  final String? levelName;
  final List<String>? pointTags;

  FeedbackResponse({
    required this.segments,
    this.score,
    this.levelName,
    this.pointTags,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> j) => FeedbackResponse(
        segments: (j['segments'] as List).map((e) => e.toString()).toList(),
        score: j['score'],
        levelName: j['levelName'],
        pointTags: (j['pointTags'] as List?)?.map((e) => e.toString()).toList(),
      );
}
