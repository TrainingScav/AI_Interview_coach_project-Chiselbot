// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeImpl _$$NoticeImplFromJson(Map<String, dynamic> json) => _$NoticeImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
      isNew: json['isNew'] as bool,
    );

Map<String, dynamic> _$$NoticeImplToJson(_$NoticeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date,
      'isNew': instance.isNew,
    };
