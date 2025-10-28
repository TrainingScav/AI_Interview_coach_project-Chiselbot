import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Color _nameIconColor = Colors.grey;
  Color _emailIconColor = Colors.grey;
  Color _passwordIconColor = Colors.grey;
  Color _verifyCodeIconColor = Colors.grey;

  static const Color _validColor = Colors.green;
  static const Color _invalidColor = Colors.red;
  static const Color _defaultColor = Colors.grey;

  bool _isEmailVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(
                  hintText: '이름',
                  prefixIcon:
                      Icon(FontAwesomeIcons.user, color: _nameIconColor),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'phoneNumber',
                decoration: InputDecoration(
                  hintText: '휴대전화번호',
                  prefixIcon: Icon(FontAwesomeIcons.phone),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "휴대전화번호를 입력해주세요."),
                  // 2. 정규식 패턴 체크 (010-XXXX-XXXX 또는 010XXXXXXXX)
                  FormBuilderValidators.match(
                    RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$'),
                    errorText: "올바른 휴대전화번호 형식인지 확인해주세요.",
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(
                        hintText: '이메일',
                        prefixIcon: Icon(
                          FontAwesomeIcons.envelope,
                          color: _emailIconColor,
                        ),
                      ),
                      validator: _validateEmail,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {
                        // 인증번호 담긴 이메일 보내기
                      },
                      child: Text(
                        "인증",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'verify_code',
                      decoration: InputDecoration(
                        hintText: '인증번호',
                        prefixIcon: Icon(
                          FontAwesomeIcons.circleCheck,
                          color: _verifyCodeIconColor,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: '인증번호를 입력해주세요.'),
                        FormBuilderValidators.numeric(
                            errorText: '인증번호는 숫자만 입력 가능해요.'),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: () async {
                        final verifyCode =
                            _formKey.currentState?.fields['verify_code']?.value;
                        if (verifyCode == null || verifyCode.isEmpty) {
                          setState(() {
                            _verifyCodeIconColor = _defaultColor;
                          });
                          return;
                        }

                        final isValid =
                            await _checkVerificationCode(verifyCode);

                        setState(() {
                          _isEmailVerified = isValid;
                          _verifyCodeIconColor =
                              isValid ? _validColor : _invalidColor;
                        });

                        if (!isValid) {
                          _formKey.currentState?.fields['verify_code']
                              ?.invalidate('인증번호가 일치하지 않아요.');
                        } else {
                          _formKey.currentState?.fields['verify_code']
                              ?.validate();
                        }
                      },
                      child: const Text(
                        "확인",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    color: _passwordIconColor,
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: () {
                    //
                  },
                  child: Text(
                    "회원가입",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String? _runValidation({
    required String? value,
    required FormFieldValidator<String> validator,
    required Function(Color) updateColor,
  }) {
    final error = validator.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        updateColor(error == null ? _validColor : _invalidColor);
      }
    });
    return error;
  }

  Future<bool> _checkVerificationCode(String code) async {
    // TODO: 실제 API 호출
    await Future.delayed(const Duration(milliseconds: 150));
    return code == "123456"; // 임시 검증 로직
  }

  String? _validateName(String? value) {
    final nameValidators = FormBuilderValidators.compose([
      FormBuilderValidators.required(
          errorText: '앗! 이름을 입력하지 않으셨어요. 다시 한번 확인해주세요'),
      FormBuilderValidators.minLength(2,
          errorText: '이름이 너무 짧아요. 최소 2글자 이상 입력해주세요.'),
      FormBuilderValidators.maxLength(20,
          errorText: '이름이 너무 길어요. 20글자 이하로 부탁드려요.'),
    ]);

    return _runValidation(
      value: value,
      validator: nameValidators,
      updateColor: (color) {
        setState(() {
          _nameIconColor = color;
        });
      },
    );
  }

  String? _validateEmail(String? value) {
    final emailValidators = FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: '이메일 주소를 입력해주세요.'),
      FormBuilderValidators.email(errorText: '올바른 이메일 형식인지 확인해 주세요.'),
    ]);

    return _runValidation(
      value: value,
      validator: emailValidators,
      updateColor: (color) {
        setState(() {
          _emailIconColor = color;
        });
      },
    );
  }

  String? _validatePassword(String? value) {
    final passwordValidators = FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: '비밀번호를 입력해주세요.'),
      FormBuilderValidators.password(
          errorText: '비밀번호는 8자 이상, 대/소문자, 특수문자를 섞어주세요'),
    ]);

    return _runValidation(
      value: value,
      validator: passwordValidators,
      updateColor: (color) {
        setState(() {
          _passwordIconColor = color;
        });
      },
    );
  }
}
