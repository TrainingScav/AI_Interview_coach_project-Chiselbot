import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/find_auth_data.dart';
import '../models/user_model.dart';
import '../providers/auth_notifier.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isEmailVerificationLoading = false; // 이메일 인증 요청
  bool _isCodeVerificationLoading = false; // 인증번호 확인
  bool _isSignupLoading = false; // 회원가입

  bool _isEmailVerified = false;
  bool _isCodeSent = false;

  // 이메일 인증 요청
  Future<void> _requestEmailVerification() async {
    // 이메일 필드만 검증
    final emailField = _formKey.currentState?.fields['email'];
    if (emailField?.validate() != true) return;

    final email = emailField?.value as String?;
    if (email == null || email.isEmpty) return;

    setState(() => _isEmailVerificationLoading = true);

    try {
      await ref.read(authRepositoryProvider).requestVerification(
            contact: email,
            type: AuthType.signUp,
          );

      setState(() {
        _isCodeSent = true;
        _isEmailVerificationLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증번호가 이메일로 전송되었습니다.')),
        );
      }
    } catch (e) {
      setState(() => _isEmailVerificationLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증번호 전송 실패: ${e.toString()}')),
        );
      }
    }
  }

  // 인증번호 확인
  Future<void> _verifyEmailCode() async {
    final verifyCodeField = _formKey.currentState?.fields['verify_code'];
    final emailField = _formKey.currentState?.fields['email'];

    if (verifyCodeField?.validate() != true) return;

    final code = verifyCodeField?.value as String?;
    final email = emailField?.value as String?;

    if (code == null || code.isEmpty || email == null) return;

    setState(() => _isCodeVerificationLoading = true);

    try {
      final result = await ref.read(authRepositoryProvider).verifyCode(
            contact: email,
            code: code,
            type: AuthType.signUp,
          );

      // verifyCode는 AuthResultModel을 반환하지만 회원가입은 결과 없음
      // 성공 시 예외가 발생하지 않으므로 성공으로 간주
      setState(() {
        _isEmailVerified = true;
        _isCodeVerificationLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
        );
      }
    } catch (e) {
      setState(() {
        _isEmailVerified = false;
        _isCodeVerificationLoading = false;
      });

      _formKey.currentState?.fields['verify_code']
          ?.invalidate('인증번호가 일치하지 않아요.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 실패: ${e.toString()}')),
        );
      }
    }
  }

  // 회원가입
  Future<void> _signUp() async {
    // 1. 이메일 인증 확인
    if (!_isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 인증을 먼저 완료해주세요.')),
      );
      return;
    }

    // 2. 전체 폼 검증
    if (_formKey.currentState?.validate() != true) return;

    // 3. 폼 데이터 저장 및 추출
    _formKey.currentState?.save();
    final formData = _formKey.currentState?.value;

    final name = formData?['name'] as String?;
    final phoneNumber = formData?['phoneNumber'] as String?;
    final email = formData?['email'] as String?;
    final password = formData?['password'] as String?;

    if (name == null ||
        phoneNumber == null ||
        email == null ||
        password == null) {
      return;
    }

    setState(() => _isSignupLoading = true);

    try {
      // 4. UserModel 생성
      final user = UserModel(
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        name: name,
      );

      // 5. 회원가입 호출
      await ref.read(authNotifierProvider.notifier).signUp(user);

      setState(() => _isSignupLoading = false);

      // 6. 성공 다이얼로그
      if (mounted) {
        await _showSuccessDialog();
        if (mounted) {
          Navigator.of(context).pop(); // 로그인 화면으로
        }
      }
    } catch (e) {
      setState(() => _isSignupLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
        );
      }
    }
  }

  // 성공 다이얼로그
  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(FontAwesomeIcons.check, color: Colors.green),
              SizedBox(width: 16),
              Text('회원가입 완료'),
            ],
          ),
          content: const Text('회원가입이 완료되었습니다.\n로그인 화면으로 이동합니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // 이름
              FormBuilderTextField(
                name: 'name',
                textInputAction: TextInputAction.next,
                enabled: !_isSignupLoading,
                decoration: InputDecoration(
                  labelText: '이름',
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              // 휴대전화번호
              FormBuilderTextField(
                name: 'phoneNumber',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                enabled: !_isSignupLoading,
                decoration: InputDecoration(
                    labelText: '휴대전화번호',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "휴대전화번호를 입력해주세요."),
                  FormBuilderValidators.match(
                    RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$'),
                    errorText: "올바른 휴대전화번호 형식인지 확인해주세요.",
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              // 이메일 + 인증 버튼
              Row(children: [
                Flexible(
                  child: FormBuilderTextField(
                    name: 'email',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: '이메일',
                    ),
                    validator: _validateEmail,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        color:
                            _isCodeSent ? Colors.grey.shade700 : Colors.grey),
                  ),
                  onPressed: _isEmailVerificationLoading || _isCodeSent
                      ? null
                      : _requestEmailVerification,
                  child: _isEmailVerificationLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        )
                      : Text(
                          _isCodeSent ? "전송됨" : "인증",
                          style: TextStyle(
                              color: _isCodeSent
                                  ? Colors.grey.shade700
                                  : Colors.white),
                        ),
                ),
              ]),

              const SizedBox(height: 16),
              // 인증번호 + 확인 버튼
              Row(
                children: [
                  Flexible(
                    child: FormBuilderTextField(
                      name: 'verify_code',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '인증번호',
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
                      side: BorderSide(
                          color: _isEmailVerified
                              ? Colors.grey.shade700
                              : Colors.grey),
                    ),
                    onPressed: _isCodeVerificationLoading ||
                            !_isCodeSent ||
                            _isEmailVerified
                        ? null
                        : _verifyEmailCode,
                    child: _isCodeVerificationLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          )
                        : Text(
                            _isEmailVerified ? "완료" : "확인",
                            style: TextStyle(
                                color: _isEmailVerified
                                    ? Colors.grey.shade700
                                    : Colors.white),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 비밀번호
              FormBuilderTextField(
                name: 'password',
                textInputAction: TextInputAction.done,
                obscureText: true,
                enabled: !_isSignupLoading,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 32),
              // 회원가입 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: _isSignupLoading ? null : _signUp,
                child: _isSignupLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 3.0),
                      )
                    : const Text(
                        "회원가입",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
          errorText: '앗! 이름을 입력하지 않으셨어요. 다시 한번 확인해주세요'),
      FormBuilderValidators.minLength(2,
          errorText: '이름이 너무 짧아요. 최소 2글자 이상 입력해주세요.'),
      FormBuilderValidators.maxLength(20,
          errorText: '이름이 너무 길어요. 20글자 이하로 부탁드려요.'),
    ])(value);
  }

  String? _validateEmail(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: '이메일 주소를 입력해주세요.'),
      FormBuilderValidators.email(errorText: '올바른 이메일 형식인지 확인해 주세요.'),
    ])(value);
  }

  String? _validatePassword(String? value) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: '비밀번호를 입력해주세요.'),
      FormBuilderValidators.password(
          errorText: '비밀번호는 8자 이상, 대/소문자, 특수문자를 섞어주세요'),
    ])(value);
  }
}
