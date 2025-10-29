import 'package:ai_interview/screens/find_id_pw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'signup_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text("이메일 로그인"),
              const SizedBox(height: 40),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  hintText: '이메일',
                  prefixIcon: Icon(FontAwesomeIcons.envelope),
                ),
                validator: FormBuilderValidators.required(
                  errorText: '이메일을 입력해주세요',
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호',
                  prefixIcon: Icon(FontAwesomeIcons.lock),
                ),
                validator: FormBuilderValidators.required(
                  errorText: '비밀번호를 입력해주세요',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: () {},
                  child: Text(
                    "로그인",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: Text(
                        "회원가입",
                        style: TextStyle(color: Colors.white),
                      )),
                  Text(" | "),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FindIdPwScreen()));
                      },
                      child: Text(
                        "아이디 · 비밀번호 찾기",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
