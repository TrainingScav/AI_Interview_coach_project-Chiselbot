import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/inquiry.dart';
import 'app_providers.dart';

// 로그인 연동 전 임시 값
final currentUserIdProvider = StateProvider<int>((_) => 1);
final currentAdminIdProvider = StateProvider<int?>((_) => null);
// null이면 일반 사용자 모드, 숫자면 관리자 모드(예: 100)

final inquiriesProvider =
    FutureProvider.autoDispose<List<Inquiry>>((ref) async {
  return ref.read(apiProvider).fetchInquiries();
});

final inquiryDetailProvider =
    FutureProvider.family.autoDispose<Inquiry, int>((ref, inquiryId) async {
  return ref.read(apiProvider).fetchInquiry(inquiryId);
});

class CreateInquiryNotifier extends StateNotifier<AsyncValue<Inquiry?>> {
  CreateInquiryNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> submit({required String title, required String content}) async {
    state = const AsyncValue.loading();
    try {
      final userId = ref.read(currentUserIdProvider);
      final created = await ref.read(apiProvider).createInquiry(
            userId: userId,
            title: title,
            content: content,
          );
      state = AsyncValue.data(created);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final createInquiryProvider =
    StateNotifierProvider<CreateInquiryNotifier, AsyncValue<Inquiry?>>(
  (ref) => CreateInquiryNotifier(ref),
);

class AnswerInquiryNotifier extends StateNotifier<AsyncValue<Inquiry?>> {
  AnswerInquiryNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> submit({required int inquiryId, required String answer}) async {
    state = const AsyncValue.loading();
    try {
      final adminId = ref.read(currentAdminIdProvider);
      if (adminId == null) throw '관리자 권한이 필요합니다.';
      final updated = await ref.read(apiProvider).answerInquiry(
            inquiryId: inquiryId,
            adminId: adminId,
            answerContent: answer,
          );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final answerInquiryProvider =
    StateNotifierProvider<AnswerInquiryNotifier, AsyncValue<Inquiry?>>(
  (ref) => AnswerInquiryNotifier(ref),
);
