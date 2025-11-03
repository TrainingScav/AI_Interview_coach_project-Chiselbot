import '../models/cards.dart';
import '../widgets/card_view.dart';
import '../widgets/qna_quick_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/app_providers.dart';

import '../models/api_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core/constants.dart';
import '../models/cards.dart';
import 'card_view.dart';
import 'notice_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _isLoading = true;
  final double _cardRatio = .15;

  // 선택된 카드 인덱스(하이라이트 용)
  int _selectedIndex = -1;

  // (DataLoader가 1L=Java, 2L=Oracle, 3L=CSS로 넣는다는 전제)
  Map<String, int> _nameToId = const {
    'java': 1,
    'oracle': 2,
    'css': 3,
  };

  // 화면 라벨 보정 (UI 카드명 ↔ 카테고리명 차이 흡수)
  final Map<String, String> _aliases = const {
    'html/css': 'css',
    'mysql': 'oracle', // 화면엔 MySQL로 보여도 백은 Oracle로 관리 중
  };

  // 문자열 정규화 함수(공백제거+소문자)
  String _norm(String s) => s.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // 최초 UI 스켈레톤 보여주기 용
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _isLoading = false);
  }

  // ---- 카드 제목을 받아 카테고리 id로 변환 ----
  int? _resolveCategoryIdByTitle(String title) {
    final key = _norm(title);
    final canonical = _aliases[key] ?? key;
    return _nameToId[canonical];
  }

  // ---- 인덱스 기반이 아니라 제목으로 매핑 ----
  Future<void> _startByTitle(String title) async {
    final categoryId = _resolveCategoryIdByTitle(title);
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카테고리 매핑 실패: $title')),
      );
      return;
    }

    final qna = AppProviders.of(context).qna;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await qna.loadQuestion(categoryId: categoryId, level: 'LEVEL_1');

    if (mounted) Navigator.pop(context);

    if (qna.error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('질문 불러오기 실패: ${qna.error}')));
      return;
    }

    if (qna.currentQuestion != null && mounted) {
      Navigator.pushNamed(context, '/chat');
      setState(() => _selectedIndex = -1);
    }
  }

  void _onCardTap(int newIndex, List<CardData> cards) {
    setState(() {
      _selectedIndex = _selectedIndex == newIndex ? -1 : newIndex;
    });
    if (_selectedIndex == -1) return;
    final title = cards[_selectedIndex].title;
    _startByTitle(title);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitles(context, mediaQuery),
        Divider(color: Colors.grey.shade800),
        NoticeView(),
        if (_isLoading)
          SizedBox(
            height: mediaQuery.size.height * _cardRatio * 3,
            child: const Center(
              child: SpinKitCircle(
                color: Colors.grey,
                duration: Duration(milliseconds: 300),
              ),
            ),
          )
        else ...[
          _buildCategorySection(
            context,
            mediaQuery,
            "백엔드",
            CardDataFactory.createBackendCards(),
          ),
          _buildCategorySection(
            context,
            mediaQuery,
            "프론트엔드",
            CardDataFactory.createFrontendCards(),
          ),
          _buildCategorySection(
            context,
            mediaQuery,
            "데이터베이스",
            CardDataFactory.createDatabaseCards(),
          ),
        ],
      ],
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    MediaQueryData mediaQuery,
    String categoryTitle,
    List<CardData> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade800, height: 32),
        Padding(
          padding: EdgeInsets.only(
            left: mediaQuery.size.width * .1,
            top: 1,
            bottom: 1,
          ),
          child: Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        SizedBox(
          height: mediaQuery.size.height * _cardRatio,
          child: CardView(
            items: cards,
            onCardTap: (i) => _onCardTap(i, cards), // ← 인덱스는 하이라이트용
            selectedIndex: _selectedIndex,
          ),
        ),
      ],
    );
  }

  Widget _buildTitles(BuildContext context, MediaQueryData mediaQuery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top,
            left: mediaQuery.size.width * .05,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Constants.logoAddress,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                "안녕하세요, ",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "개발자님",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
