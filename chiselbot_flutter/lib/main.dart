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
import 'package:ai_interview/screens/main_screen.dart';
import 'screens/login_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Interview Coach",
      theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.black,
          textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledForegroundColor: Colors.red)),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.white),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          )),
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
      },
      initialRoute: '/',
    );
  }
}
