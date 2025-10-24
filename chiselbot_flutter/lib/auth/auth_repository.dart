/*
abstract class AuthRepository {
  Future<({String access, String refresh})> login(
      {required String id, required String pw});
  Future<String> refresh(String refreshToken);
  Future<void> logout(String accessToken, String refreshToken);
}

// 나중에 실제 API 붙일 때만 이 구현체 작성.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<({String access, String refresh})> login(
      {required String id, required String pw}) async {
    // TODO: /auth/login 호출 후 토큰 반환
    throw UnimplementedError();
  }

  @override
  Future<String> refresh(String refreshToken) async {
    // TODO: /auth/refresh
    throw UnimplementedError();
  }

  @override
  Future<void> logout(String accessToken, String refreshToken) async {
    // TODO: /auth/logout
    throw UnimplementedError();
  }
}
*/
