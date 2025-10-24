import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final logoAddress = 'assets/images/chisel.png';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(logoAddress),
        SizedBox(height: 16),
        const Text(
          "ChiselBot",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32),
        ),
      ],
    );
  }
}
