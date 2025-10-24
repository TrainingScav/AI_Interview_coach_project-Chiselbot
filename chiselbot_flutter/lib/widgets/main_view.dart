import 'package:ai_interview/models/cards.dart';
import 'package:ai_interview/widgets/card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCardTap(int newIndex) {
    setState(() {
      if (_selectedIndex == newIndex) {
        _selectedIndex = -1;
      } else {
        _selectedIndex = newIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final bool shouldShowSecondList = _selectedIndex == 0;

    final Widget secondCardList = SizedBox(
      key: const ValueKey('skillCardView'),
      height: mediaQuery.size.height * _cardRatio,
      child: CardView(items: CardDataFactory.createSkillCards()),
    );

    // 숨겨진 상태일 때 표시할 위젯 (빈 컨테이너)
    final Widget hiddenCardList = SizedBox(
      key: const ValueKey('hidden'),
      height: 0,
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitles(context, mediaQuery),
        if (_isLoading)
          SizedBox(
            height: mediaQuery.size.height * _cardRatio * 2,
            child: Center(
              child: SpinKitCircle(
                color: Colors.grey,
                duration: Duration(milliseconds: 1000),
              ),
            ),
          )
        else ...[
          SizedBox(
            height: mediaQuery.size.height * _cardRatio,
            child: CardView(
              items: CardDataFactory.createAskCards(),
              onCardTap: _onCardTap,
              selectedIndex: _selectedIndex,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -3,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: shouldShowSecondList ? secondCardList : hiddenCardList,
          ),
        ],
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
            left: mediaQuery.size.width * .1,
          ),
          child: const Text("WELCOME BACK,",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
        ),
        Padding(
          padding: EdgeInsets.only(left: mediaQuery.size.width * .1),
          child: const Text("(USERNAME)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        )
      ],
    );
  }
}
