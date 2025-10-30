import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../providers/find_auth_notifier.dart';

class VerifyInput extends ConsumerStatefulWidget {
  // 💡 [추후 작업] 이 위젯은 Id 찾기와 Pw 찾기 모두에서 재사용됩니다.
  // Pw 찾기 시에는 인증 성공 후 다음 단계(비밀번호 재설정 폼)로 이동해야 함을 상위 위젯에 알려야 할 수 있습니다.
  final VoidCallback? onVerificationSuccess;

  const VerifyInput({super.key, this.onVerificationSuccess});

  @override
  ConsumerState<VerifyInput> createState() => _VerifyInputState();
}

class _VerifyInputState extends ConsumerState<VerifyInput> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _verifyCode() async {
    // 폼 유효성 검사
    if (_formKey.currentState?.validate() != true) return;

    // 폼 값 저장 및 인증번호 추출
    _formKey.currentState?.save();
    final formData = _formKey.currentState?.value;
    final code = formData?['verifyCode'] as String?;

    if (code == null) return;

    // Notifier 접근
    final notifier = ref.read(findAuthNotifierProvider.notifier);

    try {
      // 1. 인증번호 확인 비동기 작업 시작
      await notifier.verifyCode(code: code);

      // 2. 인증 성공 시 콜백 호출
      if (widget.onVerificationSuccess != null) {
        widget.onVerificationSuccess!();
      }

      // [추후 작업] 아이디 찾기 성공 시에는 상위 위젯이 상태(isVerified)를 보고 결과를 표시합니다.
    } catch (e) {
      // 3. 실패 처리: 현재 위젯의 컨텍스트를 사용하여 SnackBar 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증번호 확인 실패: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findAuthNotifierProvider);
    final isLoading = state.isLoading && state.isCodeSent; // 인증번호 확인 중일 때 로딩 표시

    // 인증번호가 전송된 연락처 (UI에 표시하여 사용자에게 안내)
    final contact = state.inputContact ?? '연락처';

    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 연락처 표시 및 재요청 버튼 (추후 타이머 기능 추가 가능)
          Text(
            '$contact로 인증번호가 전송되었습니다.',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              // 1. 인증번호 입력 필드
              Expanded(
                child: FormBuilderTextField(
                  name: 'verifyCode',
                  decoration: const InputDecoration(
                    hintText: '인증번호 6자리',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
                  enabled:
                      !isLoading && !state.isVerified, // 로딩 중이거나 이미 인증했으면 비활성화
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: "인증번호를 입력해주세요."),
                    FormBuilderValidators.numeric(errorText: "숫자만 입력 가능합니다."),
                    FormBuilderValidators.equalLength(6,
                        errorText: "6자리를 입력해주세요."),
                  ]),
                ),
              ),

              const SizedBox(width: 16),

              // 2. 확인 버튼
              ElevatedButton(
                onPressed: isLoading || state.isVerified ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 3.0),
                      )
                    : const Text(
                        '확인',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
