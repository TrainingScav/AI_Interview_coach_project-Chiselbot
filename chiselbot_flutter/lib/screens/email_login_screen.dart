import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
                  hintText: 'example@gmail.com',
                  prefixIcon: Icon(FontAwesomeIcons.envelope),
                ),
                validator:
                    FormBuilderValidators.email(errorText: '올바른 이메일을 입력하세요'),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'password',
                  prefixIcon: Icon(FontAwesomeIcons.lock),
                ),
                validator: FormBuilderValidators.password(
                    errorText: '올바른 비밀번호를 입력하세요'),
                // 최소 8자 이상
                // 최소 1개의 소문자 (a-z)
                // 최소 1개의 대문자 (A-Z)
                // 최소 1개의 숫자 (0-9)
                // 최소 1개의 특수문자 (!@#$%^&* 등)
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
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
