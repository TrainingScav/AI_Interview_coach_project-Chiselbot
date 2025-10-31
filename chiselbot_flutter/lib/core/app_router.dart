import 'package:flutter/material.dart';

import '../screens/chat/chat_screen.dart';
import '../screens/email_login_screen.dart';
import '../screens/find_id_pw_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/qna/qna_detail_screen.dart';
import '../screens/qna/qna_form_screen.dart';
import '../screens/qna/qna_list_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/splash_screen.dart';

class RoutePaths {
  static const root = '/';
  static const main = '/main';
  static const chat = '/chat';
  static const login = '/login';
  static const settings = '/settings';
  static const qna = '/qna';
  static const qnaNew = '/qna/new';
  static const qnaDetail = '/qna/detail';
  static const findIdPw = '/findIdPw';
  static const emailLogin = '/emailLogin'; // EmailLoginScreen
  static const onboarding = '/onboarding'; // OnboardingScreen
}

class QnaDetailArgs {
  final int inquiryId;

  QnaDetailArgs(this.inquiryId);
}

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.root:
        // return MaterialPageRoute(builder: (_) => const SplashScreen());
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case RoutePaths.main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case RoutePaths.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RoutePaths.findIdPw:
        return MaterialPageRoute(builder: (_) => const FindIdPwScreen());
      case RoutePaths.emailLogin:
        return MaterialPageRoute(builder: (_) => const EmailLoginScreen());
      case RoutePaths.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RoutePaths.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RoutePaths.chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case RoutePaths.qna:
        return MaterialPageRoute(builder: (_) => const QnaListScreen());
      case RoutePaths.qnaNew:
        return MaterialPageRoute(builder: (_) => const QnaFormScreen());
      case RoutePaths.qnaDetail:
        final args = settings.arguments;
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => QnaDetailScreen(inquiryId: args));
        } else if (args is QnaDetailArgs) {
          return MaterialPageRoute(
              builder: (_) => QnaDetailScreen(inquiryId: args.inquiryId));
        } else {
          return _error('Invalid arguments for /qna/detail');
        }

      default:
        return _unknown(settings.name);
    }
  }

  static Route<dynamic> _unknown(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Unknown Route')),
        body: Center(child: Text('Unknown route: $name')),
      ),
    );
  }

  static Route<dynamic> _error(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
