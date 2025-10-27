import 'package:ai_interview/screens/qna/qna_detail_screen.dart';
import 'package:ai_interview/screens/qna/qna_form_screen.dart';
import 'package:ai_interview/screens/qna/qna_list_screen.dart';
import 'package:ai_interview/screens/splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_interview/screens/chat/chat_screen.dart';
import 'package:ai_interview/screens/main_screen.dart';
import 'package:ai_interview/routes/app_router.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Interview Coach",
      theme: FlexThemeData.light(
          scheme: FlexScheme.deepBlue,
          fontFamily: GoogleFonts.poppins().fontFamily),
      darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.deepBlue,
          fontFamily: GoogleFonts.poppins().fontFamily),
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainScreen(),
        '/chat': (context) => const ChatScreen(),
      },
      // onGenerateRoute 외부로 분리
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
