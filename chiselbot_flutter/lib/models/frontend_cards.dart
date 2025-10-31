import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FrontendCards {
  String title;
  Icon icon;

  FrontendCards({
    required this.title,
    required this.icon,
  });
}

List<FrontendCards> generateFrontend() {
  List<String> titles = [
    "HTML/CSS",
    "JavaScript",
    "Flutter",
  ];

  List<Icon> icons = [
    const Icon(FontAwesomeIcons.html5),
    const Icon(FontAwesomeIcons.js),
    const Icon(FontAwesomeIcons.flutter),
  ];

  List<FrontendCards> list = List.generate(
    titles.length,
    (index) => FrontendCards(title: titles[index], icon: icons[index]),
  );

  return list;
}
