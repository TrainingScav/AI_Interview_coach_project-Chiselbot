import 'dart:math';

import 'package:ai_interview/models/ask_cards.dart';
import 'package:flutter/material.dart';
import 'package:ai_interview/screens/chat/chat_screen.dart';

class AskCardView extends StatefulWidget {
  const AskCardView({super.key});

  @override
  State<AskCardView> createState() => _AskCardViewState();
}

class _AskCardViewState extends State<AskCardView> {
  List<AskCards> pageItems = generateAsk();
  PageController? pageController;
  var viewPortFraction = .3;
  double? pageOffset = 0;
  Size? size;

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: 0, viewportFraction: viewPortFraction)
          ..addListener(
            () {
              setState(() {
                pageOffset = pageController!.page;
              });
            },
          );
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return PageView.builder(
      controller: pageController,
      itemCount: pageItems.length,
      itemBuilder: (context, index) {
        double scale = max(viewPortFraction,
            1 - (pageOffset! - index).abs() + viewPortFraction);
        double angleY = (pageOffset! - index).abs();
        if (angleY > .3) angleY = 1 - angleY;

        return Padding(
          padding: EdgeInsets.only(
            right: size!.width * 0.01,
            left: size!.width * 0.04,
            top: 100 - scale * 16,
            bottom: size!.width * 0.1,
          ),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, .001)
              ..rotateY(angleY),
            child: Material(
              child: InkWell(
                // 탭 가능 영역 추가
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  Navigator.pushNamed(context, '/chat');
                  // 라우트가 없다면 위 한 줄 대신 아래 사용:
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(80),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: FittedBox(child: pageItems[index].icon),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Text(
                                pageItems[index].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
