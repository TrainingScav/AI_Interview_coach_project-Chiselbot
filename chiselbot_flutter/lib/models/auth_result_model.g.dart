// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResultModelImpl _$$AuthResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResultModelImpl(
      token: json['token'] as String?,
      userId: json['userId'] as String?,
      foundId: json['foundId'] as String?,
      resetToken: json['resetToken'] as String?,
    );

Map<String, dynamic> _$$AuthResultModelImplToJson(
        _$AuthResultModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'foundId': instance.foundId,
      'resetToken': instance.resetToken,
    };
