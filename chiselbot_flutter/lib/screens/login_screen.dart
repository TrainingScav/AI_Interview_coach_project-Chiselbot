import 'package:ai_interview/screens/email_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKakaoLoginButton(),
            const SizedBox(height: 16),
            _buildGoogleLoginButton(),
            const SizedBox(height: 16),
            _buildEmailLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildKakaoLoginButton() {
    final imgAddress = 'assets/images/kakao_login_black.png';
    return InkWell(
      onTap: () {
        //
      },
      child: Container(
        height: 42,
        width: 185,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                imgAddress,
                height: 28,
              ),
              Text(
                "카카오 로그인",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton() {
    return InkWell(
      onTap: () {
        //
      },
      child: Container(
        height: 42,
        width: 185,
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesomeIcons.google,
                color: Colors.black,
                size: 20,
              ),
              Text(
                "  구글 로그인 ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailLoginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EmailLoginScreen()));
      },
      child: Container(
        height: 40,
        width: 185,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(210),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesomeIcons.envelope,
                color: Colors.black,
                size: 20,
              ),
              Text(
                "이메일 로그인",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
