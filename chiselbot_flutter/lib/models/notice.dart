import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart'; // ← 추가!

@freezed
class Notice with _$Notice {
  factory Notice({
    required int id,
    required String title,
    required String content,
    required String date,
    required bool isNew,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}
