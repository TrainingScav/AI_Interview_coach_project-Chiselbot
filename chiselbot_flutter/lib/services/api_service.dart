import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../models/inquiry.dart';

class ApiService {
  final String baseUrl;
  String? _jwt; // 로그인 후 저장

  ApiService(this.baseUrl);

  void setToken(String? token) => _jwt = token;

  Map<String, String> _headers({bool jsonBody = true}) {
    final h = <String, String>{};
    if (jsonBody) h['Content-Type'] = 'application/json; charset=utf-8';
    if (_jwt != null && _jwt!.isNotEmpty) h['Authorization'] = 'Bearer $_jwt';
    return h;
  }

  // (선택) 로그인 – 백엔드 /api/users/login 응답 형태에 맞춰 수정하세요.
  Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final m = jsonDecode(res.body);
    if (res.statusCode == 200 && m['success'] == true) {
      final token = m['data']['token'] as String;
      setToken(token);
      return token;
    }
    throw Exception(m['error'] ?? '로그인 실패');
  }

  // 카테고리 목록
  Future<List<InterviewCategory>> fetchCategories() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/interview/categories'),
      headers: _headers(jsonBody: false),
    );
    final m = jsonDecode(res.body);
    if (res.statusCode == 200) {
      // 백에서 success 래퍼 안 쓰면 바로 List 처리
      if (m is List) {
        return m
            .map<InterviewCategory>((e) => InterviewCategory.fromJson(e))
            .toList();
      }
      // CommonResponseDto.success 사용 시
      final env = ApiEnvelope.fromJson(m, (obj) => obj);
      final list =
          (env.data as List).map((e) => InterviewCategory.fromJson(e)).toList();
      return list;
    }
    throw Exception('카테고리 조회 실패');
  }

  // 카테고리/레벨로 질문 1개 가져오기 (백엔드에서 하나 골라 내려주는 API 필요)
  // 예: GET /api/interview/questions/one?categoryId=1&level=LEVEL_1
  Future<InterviewQuestion> fetchOneQuestion({
    required int categoryId,
    required String level,
  }) async {
    final uri = Uri.parse('$baseUrl/api/interview/questions/one').replace(
        queryParameters: {'categoryId': '$categoryId', 'level': level});
    final res = await http.get(uri, headers: _headers(jsonBody: false));
    final m = jsonDecode(res.body);
    if (res.statusCode == 200) {
      if (m is Map && m['success'] == true) {
        return InterviewQuestion.fromJson(m['data']);
      }
      return InterviewQuestion.fromJson(m);
    }
    throw Exception('질문 조회 실패');
  }

  // 코칭 받기: POST /api/interview/coach
  Future<CoachFeedback> coach(
      {required int questionId, required String userAnswer}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/interview/coach'),
      headers: _headers(),
      body: jsonEncode({'questionId': questionId, 'userAnswer': userAnswer}),
    );
    final m = jsonDecode(res.body);
    if (res.statusCode == 200) {
      // CommonResponseDto.success 래퍼
      if (m is Map && m['success'] == true) {
        return CoachFeedback.fromJson(m['data']);
      }
      // 래퍼가 없다면 바로 파싱
      return CoachFeedback.fromJson(m);
    }
    throw Exception(m['error'] ?? '코칭 요청 실패');
  }
  // ==== QnA (1:1 문의) ====

  // 목록 조회: GET /api/inquiries
  Future<List<Inquiry>> fetchInquiries() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/inquiries'),
      headers: _headers(jsonBody: false),
    );
    final m = jsonDecode(res.body);
    if (res.statusCode == 200) {
      // CommonResponseDto.success 래퍼/비래퍼 모두 호환
      final list = (m is Map && m['success'] == true) ? m['data'] : m;
      return (list as List).map((e) => Inquiry.fromJson(e)).toList();
    }
    throw Exception(m is Map ? (m['error'] ?? '문의 목록 조회 실패') : '문의 목록 조회 실패');
  }

  // 상세 조회: GET /api/inquiries/{id}
  Future<Inquiry> fetchInquiryDetail(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/inquiries/$id'),
      headers: _headers(jsonBody: false),
    );
    final m = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final data = (m is Map && m['success'] == true) ? m['data'] : m;
      return Inquiry.fromJson(data as Map<String, dynamic>);
    }
    throw Exception(m is Map ? (m['error'] ?? '문의 상세 조회 실패') : '문의 상세 조회 실패');
  }

  // 사용자 문의 등록: POST /api/inquiries
  Future<void> createInquiry(
      {required String title, required String content}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/inquiries'),
      headers: _headers(),
      body: jsonEncode({'title': title, 'content': content}),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      final m = jsonDecode(res.body);
      throw Exception(m is Map ? (m['error'] ?? '문의 등록 실패') : '문의 등록 실패');
    }
  }

  // 관리자 답변 등록: POST /api/inquiries/{id}/answer
  Future<void> answerInquiry(
      {required int inquiryId, required String answer}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/inquiries/$inquiryId/answer'),
      headers: _headers(),
      body: jsonEncode({'answer': answer}),
    );
    if (res.statusCode != 200) {
      final m = jsonDecode(res.body);
      throw Exception(m is Map ? (m['error'] ?? '답변 등록 실패') : '답변 등록 실패');
    }
  }
}
