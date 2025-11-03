import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notice.dart';
import '../repositories/i_notice_repository.dart';
import '../repositories/dummy_notice_repository.dart';

// =======================================================
// 1. INoticeRepository를 제공하는 Provider (의존성 주입)
// =======================================================
final noticeRepositoryProvider = Provider<INoticeRepository>((ref) {
  // 현재는 Dummy 구현체를 사용하며, 실제 서버 통신 시 교체됨
  return DummyNoticeRepository();
});

// =======================================================
// 2. 공지사항 목록을 가져오는 FutureProvider
// =======================================================
final noticesProvider = FutureProvider<List<Notice>>((ref) async {
  final repository = ref.watch(noticeRepositoryProvider);
  return await repository.getNotices();
});

// =======================================================
// 3. 특정 ID의 공지사항을 가져오는 FutureProvider.family
// =======================================================
final noticeProvider = FutureProvider.family<Notice, int>((ref, id) async {
  final repository = ref.watch(noticeRepositoryProvider);
  return await repository.getNoticeById(id);
});
