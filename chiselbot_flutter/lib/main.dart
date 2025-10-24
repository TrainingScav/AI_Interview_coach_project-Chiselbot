import 'package:ai_interview/screens/login_screen.dart';
import 'package:ai_interview/screens/splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '');

  await printKeyHash();

  runApp(ProviderScope(child: MyApp()));
}

Future<void> printKeyHash() async {
  try {
    final keyHash = await KakaoSdk.origin;
    print("현재 사용 중인 키 해시: $keyHash");
  } catch (e) {
    print("키 해시를 가져오는 중 오류 발생: $e");
  }
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
      // themeMode: ThemeMode.system,
      // home: const SplashScreen(),
      home: const LoginScreen(),
    );
  }
}
