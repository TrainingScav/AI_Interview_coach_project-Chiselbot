// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeImpl _$$NoticeImplFromJson(Map<String, dynamic> json) => _$NoticeImpl(
      id: (json['noticeId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['createdAt'] as String,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      isVisible: json['isVisible'] as bool? ?? true,
      modifiedAt: json['modifiedAt'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
    );

Map<String, dynamic> _$$NoticeImplToJson(_$NoticeImpl instance) =>
    <String, dynamic>{
      'noticeId': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.date,
      'viewCount': instance.viewCount,
      'isVisible': instance.isVisible,
      'modifiedAt': instance.modifiedAt,
      'authorName': instance.authorName,
    };
