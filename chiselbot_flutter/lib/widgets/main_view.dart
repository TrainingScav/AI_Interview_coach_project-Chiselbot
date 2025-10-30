import 'package:ai_interview/models/cards.dart';
import 'package:ai_interview/widgets/card_view.dart';
import 'package:ai_interview/widgets/qna_quick_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ai_interview/providers/app_providers.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _isLoading = true;
  int _selectedIndex = -1;
  final double _cardRatio = .15;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  void _onCardTap(int newIndex) async {
    setState(() {
      _selectedIndex = _selectedIndex == newIndex ? -1 : newIndex;
    });

    // 기술(index 0)은 하단 스킬 리스트를 보여주고 끝
    if (_selectedIndex == 0) return;

    // 인성/경험은 바로 질문 시작
    final categoryIdByAsk = {1: 2, 2: 3}; // 인성=2, 경험=3
    final categoryId = categoryIdByAsk[_selectedIndex];
    if (categoryId == null) return;

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
      // UX: 돌아왔을 때 리스트가 남지 않도록 선택 초기화(선택)
      setState(() => _selectedIndex = -1);
    }
  }

  Future<void> _onTapSkillSubCard(int subIndex) async {
    if (_selectedIndex != 0) return; // 기술이 아닐 때 무시

    // 기술 하위 스킬 → 카테고리 매핑
    final techSkillToCategory = {
      0: 11, // Java
      1: 12, // Python
      2: 13, // Flutter
      3: 14, // C
      4: 15, // JavaScript
      5: 16, // PHP
      6: 17, // Swift
    };
    final categoryId = techSkillToCategory[subIndex] ?? 11;

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
      // 선택 유지 or 초기화는 취향(초기화하려면 아래 주석 해제)
      // setState(() => _selectedIndex = -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final bool shouldShowSecondList = _selectedIndex == 0; // 오직 기술 선택 시만 노출

    final Widget secondCardList = SizedBox(
      key: const ValueKey('skillCardView'),
      height: mediaQuery.size.height * _cardRatio,
      child: CardView(
        items: CardDataFactory.createSkillCards(),
        onCardTap: _onTapSkillSubCard,
      ),
    );

    final Widget hiddenCardList = const SizedBox(
      key: ValueKey('hidden'),
      height: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitles(context, mediaQuery),
        if (_isLoading)
          SizedBox(
            height: mediaQuery.size.height * _cardRatio * 2,
            child: Center(
              child: SpinKitCircle(
                color: Colors.grey,
                duration: Duration(milliseconds: 500),
              ),
            ),
          )
        else ...[
          SizedBox(
            height: mediaQuery.size.height * _cardRatio,
            child: CardView(
              // items: CardDataFactory.createAskCards(),
              items: CardDataFactory.createSkillCards(),
              // onCardTap: _onCardTap,
              selectedIndex: _selectedIndex,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: shouldShowSecondList ? secondCardList : hiddenCardList,
          ),
          const QnaQuickCard(),
        ],
      ],
    );
  }

  Widget _buildTitles(BuildContext context, MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top,
        left: mediaQuery.size.width * .1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("WELCOME BACK,",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("(USERNAME)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
