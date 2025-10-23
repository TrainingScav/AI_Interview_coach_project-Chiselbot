import 'package:ai_interview/widgets/ask_card_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitles(context, mediaQuery),
        SizedBox(
          height: mediaQuery.size.height * .3,
          child: const AskCardView(),
        )
      ],
    );
  }

  Widget _buildTitles(BuildContext context, MediaQueryData mediaQuery) {
    final textTheme = Theme.of(context).textTheme;
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
