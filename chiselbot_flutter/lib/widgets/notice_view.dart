import 'package:flutter/material.dart';
import 'dart:async';

// 자동 스크롤 기능을 가진 PageView 위젯입니다.
class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  // 1. PageController: PageView의 위치를 제어합니다.
  late PageController _pageController;
  // 2. Timer: 일정한 간격으로 페이지 전환을 발생시킵니다.
  Timer? _timer;

  // 배너에 표시될 데이터 목록
  final List<Map<String, dynamic>> _bannerItems = const [
    {'title': ' 🎄 ✨ ✨ ✨ ✨ ✨ ✨  Merry Christmas ✨ ✨ ✨ ✨ ✨ ✨ 🎄 '},
    {'title': '[공지] 11월 6일(목) 개발 1차 마감 기한입니다!'},
    {'title': '[요청] UI 피드백 언제든지 자유롭게 부탁드립니다!'},
    {'title': '[필독] ChiselBot V1.5.0 대규모 업데이트 및 서비스 정책 변경 안내!!!!!!!!!!!!!!!'},
  ];

  // 현재 페이지 인덱스를 저장합니다.
  int _currentPage = 10000;
  static const int _infiniteItemCount = 2000000000;

  @override
  void initState() {
    super.initState();
    // PageController 초기화
    _pageController = PageController(initialPage: _currentPage);

    // 자동 스크롤 타이머 시작
    _startAutoScroll();
  }

  // 자동 스크롤 시작 로직 (3초마다 페이지 전환)
  void _startAutoScroll() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.hasClients) {
        // 다음 페이지 인덱스 계산 (마지막 페이지면 0으로 순환)
        // final int nextPageIndex = (_currentPage + 1) % _bannerItems.length;
        final int nextPageIndex = _currentPage + 1; // <- 수정된 부분 (나머지 연산 제거)

        _pageController.animateToPage(
          nextPageIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 배너 높이 지정
    final double bannerHeight = 16.0;

    return Center(
      child: SizedBox(
        height: bannerHeight,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          // itemCount: _bannerItems.length,
          itemCount: _infiniteItemCount,
          itemBuilder: (context, index) {
            final actualIndex = index % _bannerItems.length;
            // final item = _bannerItems[index];
            final item = _bannerItems[actualIndex];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                item['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // 넘치면 ...
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          },
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
      ),
    );
  }
}
