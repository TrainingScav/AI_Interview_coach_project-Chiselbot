import 'package:ai_interview/screens/find_id_pw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../providers/auth_notifier.dart';
import 'main_screen.dart';
import 'signup_screen.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }

      if (next.isLoggedIn && (previous == null || !previous.isLoggedIn)) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    });

    return Scaffold(
      appBar: AppBar(),
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
                decoration: InputDecoration(
                  labelText: '이메일',
                ),
                validator: FormBuilderValidators.required(
                  errorText: '이메일을 입력해주세요',
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
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
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          // 1. 폼 검증
                          if (_formKey.currentState?.validate() != true) return;
                          _formKey.currentState?.save();
                          final formData = _formKey.currentState?.value;
                          final email = formData?['email'] as String?;
                          final password = formData?['password'] as String?;

                          if (email == null || password == null) return;

                          // 2. 로그인 시도
                          await ref.read(authNotifierProvider.notifier).login(
                                email: email,
                                password: password,
                              );
                        },
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 3.0),
                        )
                      : Text(
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
