import 'package:ai_interview/models/cards.dart';
import 'package:ai_interview/widgets/card_view.dart';
import 'package:ai_interview/widgets/notice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core/constants.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _isLoading = true;
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
            selectedIndex: -1,
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
            left: mediaQuery.size.width * .1,
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
