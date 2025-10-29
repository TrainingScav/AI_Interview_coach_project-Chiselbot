import 'package:ai_interview/screens/qna/qna_form_screen.dart';
import 'package:ai_interview/screens/qna/qna_list_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_interview/screens/chat/chat_screen.dart';
import 'package:ai_interview/screens/main_screen.dart';
import 'package:ai_interview/routes/app_router.dart';
import 'package:ai_interview/providers/app_providers.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  // KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '');
  //
  // await printKeyHash();

  runApp(ProviderScope(child: MyApp()));
}

// Future<void> printKeyHash() async {
//   try {
//     final keyHash = await KakaoSdk.origin;
//     print("현재 사용 중인 키 해시: $keyHash");
//   } catch (e) {
//     print("키 해시를 가져오는 중 오류 발생: $e");
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      baseUrl: 'http://10.0.2.2:8080', // 에뮬레이터일 때 PC의 로컬서버
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Interview Coach',
        theme: FlexThemeData.light(
          scheme: FlexScheme.deepBlue,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.deepBlue,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        themeMode: ThemeMode.system,
        routes: {
          // '/': (context) => const SplashScreen(),
          '/main': (context) => const MainScreen(),
          '/chat': (context) => const ChatScreen(),
          '/qna/list': (context) => const QnaListScreen(),
          '/qna/new': (context) => const QnaFormScreen(),
        },
        // onGenerateRoute 외부로 분리
        onGenerateRoute: AppRouter.generateRoute,
        // themeMode: ThemeMode.system,
        // home: const SplashScreen(),
        home: const MainScreen(),
      ),
    );
  }
}
