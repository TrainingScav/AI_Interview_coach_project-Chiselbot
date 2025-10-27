import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

// 실행 환경에 따라 기본 baseUrl 자동 선택 (원하면 고정값으로 바꿔도 됨)
String _defaultBaseUrl() {
  if (kIsWeb) return 'http://localhost:8080';
  if (Platform.isAndroid) return 'http://10.0.2.2:8080'; // 에뮬레이터
  return 'http://localhost:8080'; // iOS 시뮬레이터/데스크탑
}

final apiProvider = Provider<ApiService>((ref) {
  const overrideBase =
      String.fromEnvironment('API_BASE'); // --dart-define=API_BASE=...
  final base = (overrideBase.isNotEmpty) ? overrideBase : _defaultBaseUrl();
  return ApiService(base);
});

// ------ 기존 인터뷰 관련 프로바이더 유지 ------
final categoriesProvider = FutureProvider<List<InterviewCategory>>((ref) async {
  return ref.read(apiProvider).fetchCategories();
});

final selectedCategoryIdProvider = StateProvider<int?>((_) => null);
final selectedLevelIdProvider = StateProvider<int?>((_) => null);

final oneQuestionProvider =
    FutureProvider.autoDispose<InterviewQuestion>((ref) async {
  final catId = ref.watch(selectedCategoryIdProvider);
  final levelId = ref.watch(selectedLevelIdProvider);
  if (catId == null) throw '카테고리를 선택하세요';
  return ref.read(apiProvider).fetchOneQuestion(
        categoryId: catId,
        levelId: levelId,
      );
});
