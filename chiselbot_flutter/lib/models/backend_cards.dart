import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackendCards {
  String title;
  Icon icon;

  BackendCards({
    required this.title,
    required this.icon,
  });
}

List<BackendCards> generateBackend() {
  List<String> titles = [
    "Java",
    "Python",
    "C",
  ];

  List<Icon> icons = [
    const Icon(FontAwesomeIcons.java),
    const Icon(FontAwesomeIcons.python),
    const Icon(FontAwesomeIcons.c),
  ];

  List<BackendCards> list = List.generate(
    titles.length,
    (index) => BackendCards(title: titles[index], icon: icons[index]),
  );

  return list;
}
