// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../models/inquiry.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client = http.Client();
  ApiService(this.baseUrl);

  // URL 조립
  Uri _build(String path, [Map<String, String>? qp]) {
    assert(baseUrl.startsWith('http'), 'Invalid baseUrl: $baseUrl');
    final root = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$root$p').replace(queryParameters: qp);
  }

  // 공용 GET/POST (타임아웃 + 상태코드 체크 + JSON 보장)
  Future<dynamic> _get(String path, {Map<String, String>? qp}) async {
    final res = await _client.get(_build(path, qp), headers: {
      'Accept': 'application/json'
    }).timeout(const Duration(seconds: 10));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw 'HTTP ${res.statusCode} ${res.reasonPhrase} - $path';
    }
    return jsonDecode(res.body);
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    final res = await _client
        .post(
          _build(path),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw 'HTTP ${res.statusCode} ${res.reasonPhrase} - $path';
    }
    return jsonDecode(res.body);
  }

  // ------------ Interview ------------
  Future<List<InterviewCategory>> fetchCategories() async {
    final body = await _get('/api/interview/categories');
    return (body as List).map((e) => InterviewCategory.fromJson(e)).toList();
  }

  Future<InterviewQuestion> fetchOneQuestion({
    required int categoryId,
    int? levelId,
  }) async {
    final body = await _get('/api/interview/question', qp: {
      'categoryId': '$categoryId',
      if (levelId != null) 'levelId': '$levelId',
    });
    return InterviewQuestion.fromJson(body);
  }

  Future<FeedbackResponse> postAnswer({
    required int questionId,
    required String answerText,
  }) async {
    final body = await _post('/api/interview/feedback', {
      'questionId': questionId,
      'answerText': answerText,
    });
    return FeedbackResponse.fromJson(body);
  }

  // ------------ QnA ------------
  Future<List<Inquiry>> fetchInquiries({int page = 0, int size = 20}) async {
    final body = await _get('/api/qna/inquiries', qp: {
      'page': '$page',
      'size': '$size',
    });

    // 서버가 배열로 주는 경우/페이징 객체로 주는 경우 모두 대응
    final list = body is List ? body : body['content'];
    if (list is! List) {
      throw 'Unexpected response shape for /api/qna/inquiries';
    }
    return list.map((e) => Inquiry.fromJson(e)).toList();
  }

  Future<Inquiry> fetchInquiry(int inquiryId) async {
    final body = await _get('/api/qna/inquiries/$inquiryId');
    return Inquiry.fromJson(body);
  }

  Future<Inquiry> createInquiry({
    required int userId,
    required String title,
    required String content,
  }) async {
    final body = await _post('/api/qna/inquiries', {
      'userId': userId,
      'title': title,
      'content': content,
    });
    return Inquiry.fromJson(body);
  }

  Future<Inquiry> answerInquiry({
    required int inquiryId,
    required int adminId,
    required String answerContent,
  }) async {
    final body = await _post('/api/qna/inquiries/$inquiryId/answer', {
      'adminId': adminId,
      'answerContent': answerContent,
    });
    return Inquiry.fromJson(body);
  }
}
