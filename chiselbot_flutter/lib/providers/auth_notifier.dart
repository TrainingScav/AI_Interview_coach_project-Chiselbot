import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../repositories/i_auth_repository.dart';
import '../repositories/dummy_auth_repository.dart';

// =======================================================
// 1. IAuthRepository Provider (기존과 동일, 재사용)
// =======================================================
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return DummyAuthRepository();
});

// =======================================================
// 2. AuthState를 관리하는 Notifier Provider
// =======================================================
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState());

  /// 로그인
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // 1. 로딩 상태 시작
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // 2. Repository 호출
      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      // 3. 사용자 정보 생성 (실제로는 서버에서 받아옴)
      final user = UserModel(
        email: email,
        password: '', // 보안상 저장하지 않음
        phoneNumber: '', // 서버에서 받아온 정보로 채워야 함
        name: '', // 서버에서 받아온 정보로 채워야 함
        userId: result.userId,
      );

      // 4. 상태 업데이트 (성공)
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        user: user,
        token: result.token,
      );

      debugPrint('[AUTH] 로그인 성공: ${result.userId}');
    } catch (e) {
      // 5. 에러 처리
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인에 실패했습니다. 아이디와 비밀번호를 확인해주세요.',
      );
      debugPrint('[AUTH] 로그인 실패: $e');
      rethrow;
    }
  }

  /// 회원가입
  Future<void> signUp(UserModel user) async {
    // 1. 로딩 상태 시작
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      // 2. Repository 호출
      await _authRepository.signUp(user);

      // 3. 상태 업데이트 (성공)
      state = state.copyWith(isLoading: false);

      debugPrint('[AUTH] 회원가입 성공: ${user.email}');
    } catch (e) {
      // 4. 에러 처리
      state = state.copyWith(
        isLoading: false,
        errorMessage: '회원가입에 실패했습니다. 다시 시도해주세요.',
      );
      debugPrint('[AUTH] 회원가입 실패: $e');
      rethrow;
    }
  }

  /// 로그아웃
  void logout() {
    state = const AuthState();
    debugPrint('[AUTH] 로그아웃');
  }

  /// 자동 로그인 체크 (추후 구현)
  Future<void> checkAuthStatus() async {
    // TODO: 저장된 토큰 확인 및 자동 로그인 처리
    // SharedPreferences 등을 사용하여 토큰 확인
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
