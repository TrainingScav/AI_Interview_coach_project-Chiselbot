// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommonResponseImpl<T> _$$CommonResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$CommonResponseImpl<T>(
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$CommonResponseImplToJson<T>(
  _$CommonResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'message': instance.message,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
