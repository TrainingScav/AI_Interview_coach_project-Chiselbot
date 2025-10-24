// import 'dart:math';
//
// import 'package:ai_interview/models/ask_cards.dart';
// import 'package:ai_interview/models/skill_cards.dart';
// import 'package:flutter/material.dart';
//
// class AskCardView extends StatefulWidget {
//   const AskCardView({super.key});
//
//   @override
//   State<AskCardView> createState() => _AskCardViewState();
// }
//
// class _AskCardViewState extends State<AskCardView> {
//   List<AskCards> askItems = generateAsk();
//   List<SkillCards> skillItems = generateSkill();
//   PageController? pageController;
//   var viewPortFraction = .75;
//   double? pageOffset = 0;
//   Size? size;
//
//   @override
//   void initState() {
//     super.initState();
//     pageController =
//         PageController(initialPage: 0, viewportFraction: viewPortFraction)
//           ..addListener(
//             () {
//               setState(() {
//                 pageOffset = pageController!.page;
//               });
//             },
//           );
//   }
//
//   @override
//   void dispose() {
//     pageController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     size = MediaQuery.of(context).size;
//
//     return PageView.builder(
//       controller: pageController,
//       itemCount: askItems.length,
//       itemBuilder: (context, index) {
//         double distance = (pageOffset! - index).abs();
//         double scale = max(0.85, 1 - distance * 0.25);
//         double angleY = distance * 0.2;
//         if (angleY > 0.15) angleY = 0.15; // 최대 회전 제한
//
//         return Padding(
//           padding: EdgeInsets.only(
//             right: size!.width * .03,
//             left: size!.width * .03,
//             top: 60 - scale * 20,
//             bottom: size!.width * .2,
//           ),
//           child: Transform(
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, .001)
//               ..rotateY(angleY),
//             child: Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(20),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.all(Radius.circular(20)),
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey.withAlpha(80),
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         Expanded(
//                           child: SizedBox(
//                             height: MediaQuery.of(context).size.height * .015,
//                           ),
//                         ),
//                         Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child:
//                                 SizedBox(width: 50, child: askItems[index].icon
//                                     //   Image.network(
//                                     //   pageItems[index].img!,
//                                     //   fit: BoxFit.contain,
//                                     // ),
//                                     ),
//                           ),
//                         ),
//                         Expanded(
//                           child: SizedBox(
//                             height: MediaQuery.of(context).size.height * .015,
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(),
//                           child: Column(
//                             children: [
//                               Text(
//                                 askItems[index].title!,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: SizedBox(
//                             height: MediaQuery.of(context).size.height * .015,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
