import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<List<InterviewCategory>> fetchCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/api/interview/categories'));
    final list = jsonDecode(res.body) as List;
    return list.map((e) => InterviewCategory.fromJson(e)).toList();
  }

  Future<InterviewQuestion> fetchOneQuestion(
      {required int categoryId, int? levelId}) async {
    final url =
        Uri.parse('$baseUrl/api/interview/question').replace(queryParameters: {
      'categoryId': '$categoryId',
      if (levelId != null) 'levelId': '$levelId',
    });
    final res = await http.get(url);
    return InterviewQuestion.fromJson(jsonDecode(res.body));
  }

  Future<FeedbackResponse> postAnswer({
    required int questionId,
    required String answerText,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/interview/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'questionId': questionId,
        'answerText': answerText,
      }),
    );
    return FeedbackResponse.fromJson(jsonDecode(res.body));
  }
}
