import 'dart:math';

import 'package:flutter/material.dart';

import '../models/cards.dart';

class CardView extends StatefulWidget {
  final List<CardData> items;
  final Function(int index)? onCardTap;
  final int selectedIndex;

  const CardView({
    super.key,
    required this.items,
    this.onCardTap,
    this.selectedIndex = -1, // 기본값 -1 (선택 없음)
  });

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  PageController? pageController;
  var viewPortFraction = .75;
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
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final cardData = widget.items[index];
        final bool isSelected = widget.selectedIndex == index;

        double distance = (pageOffset! - index).abs();
        double scale = max(0.85, 1 - distance * 0.25);
        double angleY = distance * 0.2;
        if (angleY > 0.15) angleY = 0.15; // 최대 회전 제한

        return GestureDetector(
          onTap: () {
            // 콜백 함수가 있으면 호출
            if (widget.onCardTap != null) {
              widget.onCardTap!(index);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: size!.width * .03,
              left: size!.width * .03,
              top: 40 - scale * 20,
              //bottom: size!.width * .2,
            ),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, .001)
                ..rotateY(angleY),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.grey.withAlpha(90)
                              : Colors.grey.withAlpha(50),
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .015,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(width: 50, child: cardData.icon),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .015,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Text(
                                  cardData.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .015,
                            ),
                          ),
                        ],
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
