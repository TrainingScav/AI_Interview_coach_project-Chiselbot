import 'package:ai_interview/widgets/auth/find_id_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:form_builder_validators/form_builder_validators.dart';

class FindIdPwScreen extends StatefulWidget {
  const FindIdPwScreen({super.key});

  @override
  State<FindIdPwScreen> createState() => _FindIdPwScreenState();
}

class _FindIdPwScreenState extends State<FindIdPwScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Expanded(child: _buildTabBar()),
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16),
          unselectedLabelColor: Colors.grey,
          labelPadding: EdgeInsets.all(16),
          indicatorColor: Colors.grey,
          indicatorWeight: 5,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          tabs: const [
            Text("아이디 찾기"),
            Text("비밀번호 찾기"),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // _buildIdTab(),
              FindIdForm(),
              _buildPwTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIdTab() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'findId',
                decoration: const InputDecoration(
                  hintText: '휴대폰번호',
                  prefixIcon: Icon(FontAwesomeIcons.phone),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () {
                  // 랜덤 인증번호 생성 > 휴대폰 SMS 전송
                  final verifyCode = "123456";
                  debugPrint("인증번호 : $verifyCode");
                },
                child: const Text(
                  "인증",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        const SizedBox(height: 16),
        _buildVerifyCode(),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {},
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () {},
              child: Text(
                "아이디 찾기",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }

  Widget _buildPwTab() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  hintText: '이메일',
                  prefixIcon: Icon(FontAwesomeIcons.envelope),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () {},
                child: const Text(
                  "인증",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        const SizedBox(height: 16),
        _buildVerifyCode(),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {},
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () {},
              child: Text(
                "비밀번호 찾기",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }

  Widget _buildVerifyCode() {
    return Row(
      children: [
        Expanded(
          child: FormBuilderTextField(
            name: 'verify_code',
            decoration: InputDecoration(
              hintText: '인증번호',
              prefixIcon: Icon(
                FontAwesomeIcons.circleCheck,
              ),
            ),
            // validator: _validateVerifyCode,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
            ),
            onPressed: () {
              // 인증번호가 맞는지 확인하고 아이디(**표시) 보여주기 또는 비밀번호 변경 화면으로 이동
              final userEmail = "test@test.com";
              _showSimpleDialog(context, userEmail);
            },
            child: const Text(
              "확인",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  void _showSimpleDialog(BuildContext context, String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // 모달의 내용물
          title: Row(
            children: [
              const Icon(FontAwesomeIcons.check, color: Colors.green),
              const SizedBox(width: 16),
              const Text('아이디 확인'),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(userEmail),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // 모달 닫기
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
