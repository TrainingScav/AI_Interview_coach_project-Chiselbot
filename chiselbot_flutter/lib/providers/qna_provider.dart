import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/api_models.dart'; // InterviewCategory/Question/CoachFeedback
import '../models/inquiry.dart'; // Inquiry 모델
import '../services/api_service.dart';

/// ===============================
/// (A) 면접 코칭용 - 기존 ChangeNotifier 유지
/// ===============================
class QnaProvider extends ChangeNotifier {
  final ApiService api;
  QnaProvider(this.api);

  List<InterviewCategory> categories = [];
  InterviewQuestion? currentQuestion;
  CoachFeedback? lastFeedback;

  bool loading = false;
  String? error;

  Future<void> loadCategories() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      categories = await api.fetchCategories();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuestion(
      {required int categoryId, required String level, String? skill}) async {
    error = null;
    loading = true;
    notifyListeners();
    try {
      currentQuestion =
          await api.fetchOneQuestion(categoryId: categoryId, level: level);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer(String userAnswer) async {
    if (currentQuestion == null) return;
    loading = true;
    error = null;
    lastFeedback = null;
    notifyListeners();
    try {
      lastFeedback = await api.coach(
        questionId: currentQuestion!.questionId,
        userAnswer: userAnswer,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

/// ===============================
/// (B) QnA(1:1 문의)용 - Riverpod 프로바이더 추가
/// ===============================

/// ApiService를 Riverpod에서도 쓰기 위한 Provider (baseUrl은 실제 환경에 맞게)
const String _kBaseUrl = 'http://10.0.2.2:8080'; // 에뮬레이터 기준. 실기기는 PC IP로.
final apiServiceProvider = Provider<ApiService>((ref) => ApiService(_kBaseUrl));

/// 현재 로그인한 관리자 ID (없으면 null, 있을때 1)
final currentAdminIdProvider = StateProvider<int?>((ref) => 1);

/// 문의 목록
final inquiriesProvider = FutureProvider<List<Inquiry>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchInquiries();
});

/// 문의 상세 (family)
final inquiryDetailProvider =
    FutureProvider.family<Inquiry, int>((ref, inquiryId) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchInquiryDetail(inquiryId);
});

/// 문의 등록(사용자) 컨트롤러
class CreateInquiryController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {} // 상태 초기화

  Future<void> submit({required String title, required String content}) async {
    state = const AsyncLoading();
    final api = ref.read(apiServiceProvider);
    state = await AsyncValue.guard(() async {
      await api.createInquiry(title: title, content: content);
    });
  }
}

final createInquiryProvider =
    AsyncNotifierProvider<CreateInquiryController, void>(
        () => CreateInquiryController());

/// 답변 등록(관리자) 컨트롤러
class AnswerInquiryController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({required int inquiryId, required String answer}) async {
    state = const AsyncLoading();
    final api = ref.read(apiServiceProvider);
    state = await AsyncValue.guard(() async {
      await api.answerInquiry(inquiryId: inquiryId, answer: answer);
    });
  }
}

final answerInquiryProvider =
    AsyncNotifierProvider<AnswerInquiryController, void>(
        () => AnswerInquiryController());
