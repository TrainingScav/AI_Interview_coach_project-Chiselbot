import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_response.freezed.dart';
part 'common_response.g.dart';

@Freezed(genericArgumentFactories: true)
class CommonResponse<T> with _$CommonResponse<T> {
  const factory CommonResponse({
    required bool success,
    T? data,
    String? message,
  }) = _CommonResponse<T>;

  factory CommonResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$CommonResponseFromJson(json, fromJsonT);
}
