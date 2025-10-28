import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
              _buildIdTab(),
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
        FormBuilderTextField(
          name: 'findId',
          decoration: const InputDecoration(
            hintText: '휴대폰번호를 입력해주세요',
            prefixIcon: Icon(FontAwesomeIcons.phone),
          ),
        ),
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
        FormBuilderTextField(
          name: 'email',
          decoration: const InputDecoration(
            hintText: '이메일을 입력해주세요',
            prefixIcon: Icon(FontAwesomeIcons.envelope),
          ),
        ),
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
}
