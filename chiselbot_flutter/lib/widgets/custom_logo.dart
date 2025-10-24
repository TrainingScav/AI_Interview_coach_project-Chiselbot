import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final logoAddress =
        "https://img.icons8.com/external-creatype-flat-colourcreatype/64/external-carpenter-creatype-tool-and-construction-flat-creatype-flat-colourcreatype-2.png";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(logoAddress),
        SizedBox(height: 16),
        const Text(
          "AI Interview Coach,\nChiselBot",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
