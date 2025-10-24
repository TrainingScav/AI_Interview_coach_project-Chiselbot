/*
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSession {
  final String? accessToken;
  final String? refreshToken;
  final bool isAuthenticated;
  const AuthSession({this.accessToken, this.refreshToken})
      : isAuthenticated = accessToken != null;
  const AuthSession.guest()
      : accessToken = null,
        refreshToken = null,
        isAuthenticated = false;
}

final authStateProvider =
    StateNotifierProvider<AuthState, AuthSession>((ref) => AuthState());

class AuthState extends StateNotifier<AuthSession> {
  AuthState() : super(const AuthSession.guest());

  Future<void> setTokens(
      {required String access, required String refresh}) async {
    // TODO: flutter_secure_storage 에 저장
    state = AuthSession(accessToken: access, refreshToken: refresh);
  }

  Future<void> clear() async {
    // TODO: secure_storage 에서 삭제
    state = const AuthSession.guest();
  }
}
*/
