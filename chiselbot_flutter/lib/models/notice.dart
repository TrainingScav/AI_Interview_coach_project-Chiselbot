import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

@freezed
class Notice with _$Notice {
  const Notice._();

  const factory Notice({
    @JsonKey(name: 'noticeId') required int id,
    required String title,
    required String content,
    @JsonKey(name: 'createdAt') required String date,
    @Default(0) int viewCount,
    @Default(true) bool isVisible,
    @Default('') String? modifiedAt,
    @Default('') String? authorName,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

  bool get isNew {
    try {
      final createdDate = DateTime.parse(date.replaceAll(' ', 'T'));
      final now = DateTime.now();
      final difference = now.difference(createdDate).inDays;
      return difference <= 3;
    } catch (e) {
      return false;
    }
  }
}
