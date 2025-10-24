import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

final apiProvider = Provider((ref) => ApiService('http://10.0.2.2:8080'));

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
  return ref
      .read(apiProvider)
      .fetchOneQuestion(categoryId: catId, levelId: levelId);
});
