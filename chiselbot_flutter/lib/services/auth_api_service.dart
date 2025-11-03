import 'package:dio/dio.dart';
import '../models/auth_result_model.dart';
import '../models/login/login_request_model.dart';
import 'api_service.dart';
import 'auth_client.dart';

class AuthApiService {
  final ApiService _apiService;
  final AuthClient _authClient;

  AuthApiService(this._apiService, this._authClient);

  Future<AuthResultModel> login({required LoginRequestModel request}) async {
    // 1. URL 경로 확정 (type=Local 사용)
    const String path = '/api/users/login/Local';

    try {
      final Response<Map<String, dynamic>> response =
          await _authClient.dio.post(
        path,
        data: request.toJson(), // Dio는 data 필드를 자동으로 JSON으로 직렬화
      );

      // Dio는 200 응답일 때만 try 블록을 실행
      final Map<String, dynamic> responseData = response.data!;
      final Map<String, dynamic> dataMap =
          responseData['data'] as Map<String, dynamic>;
      final AuthResultModel authResult = AuthResultModel.fromJson(dataMap);
      if (authResult.token != null) {
        _apiService.setToken(authResult.token);
      }
      return authResult;
      // // 3. 확정된 파싱 로직: CommonResponseDto의 data 필드에서 순수한 토큰 문자열 추출
      // final String token = responseData['data'] as String; //
      // // 4. 핵심: 기존 ApiService에 토큰 저장 (이후 모든 http 요청에 Authorization 헤더 자동 추가)
      // _apiService.setToken(token); //
      // return token;
    } on DioException catch (e) {
      // DioException을 사용하여 서버 에러 처리 (400, 401 등)
      final responseData = e.response?.data;
      final String errorMessage =
          responseData?['message'] ?? '알 수 없는 오류가 발생했습니다.';

      // 확정된 서버 예외 메시지 기반으로 throw
      if (errorMessage.contains('가입되지 않은 이메일입니다') ||
          errorMessage.contains('잘못된 비밀번호 입니다')) {
        throw Exception(errorMessage);
      }
      throw Exception('로그인 실패: [${e.response?.statusCode}] $errorMessage');
    } catch (e) {
      rethrow;
    }
  }
}
