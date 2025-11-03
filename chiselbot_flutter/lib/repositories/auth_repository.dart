import '../models/find_auth_data.dart';
import '../models/login/login_request_model.dart';
import '../services/auth_api_service.dart';
import 'i_auth_repository.dart';
import '../models/auth_result_model.dart';

class AuthRepository implements IAuthRepository {
  final AuthApiService authApiService;

  AuthRepository(this.authApiService);

  @override
  Future<AuthResultModel> login({
    required String email,
    required String password,
  }) async {
    // authApiService.login은 이미 AuthResultModel 전체를 반환합니다.
    final authResult = await authApiService.login(
      request: LoginRequestModel(email: email, password: password),
    );

    // DTO를 수정 없이 그대로 상위 계층 (Notifier)에 전달합니다.
    return authResult;
  }

  // 이하 IAuthRepository의 나머지 계약 메서드 구현

  @override
  Future<void> signUp(user) {
    // 회원가입 기능 구현 예정
    throw UnimplementedError('서버 구현이 보류되어 signUp 로직은 구현되지 않았습니다.');
  }

  @override
  Future<bool> requestVerification(
      {required String contact, required AuthType type}) {
    // 인증번호 요청 API 구현 예정
    throw UnimplementedError();
  }

  @override
  Future<AuthResultModel> verifyCode(
      {required String contact, required String code, required AuthType type}) {
    // 인증번호 확인 API 구현 예정
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(
      {required String resetToken, required String newPassword}) {
    // 비밀번호 재등록 API 구현 예정
    throw UnimplementedError();
  }
}
