import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notice.dart';
import '../repositories/i_notice_repository.dart';
import '../repositories/server_notice_repository.dart';
import '../services/notice_api_service.dart';

// NoticeApiService Provider
final noticeApiServiceProvider = Provider<NoticeApiService>((ref) {
  return NoticeApiService(
    'http://10.0.2.2:8080',
    // token: null,  // 필요시 인증 토큰
  );
});

// INoticeRepository Provider
final noticeRepositoryProvider = Provider<INoticeRepository>((ref) {
  // Server 사용
  final apiService = ref.watch(noticeApiServiceProvider);
  return ServerNoticeRepository(apiService);
});

// 공지사항 목록 Provider
final noticesProvider = FutureProvider<List<Notice>>((ref) async {
  final repository = ref.watch(noticeRepositoryProvider);
  return await repository.getNotices();
});

// 공지사항 상세 Provider
final noticeProvider = FutureProvider.family<Notice, int>((ref, id) async {
  final repository = ref.watch(noticeRepositoryProvider);
  return await repository.getNoticeById(id);
});
