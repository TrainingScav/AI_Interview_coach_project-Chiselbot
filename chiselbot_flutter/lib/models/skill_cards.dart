import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkillCards {
  String title;
  Icon icon;
  SkillCards({
    required this.title,
    required this.icon,
  });
}

List<SkillCards> generateSkill() {
  List<String> titles = [
    "Java",
    "Python",
    "Flutter",
    "C",
    "JavaScript",
    "PHP",
    "Swift",
  ];

  List<Icon> icons = [
    const Icon(FontAwesomeIcons.java),
    const Icon(FontAwesomeIcons.python),
    const Icon(FontAwesomeIcons.flutter),
    const Icon(FontAwesomeIcons.c),
    const Icon(FontAwesomeIcons.js),
    const Icon(FontAwesomeIcons.php),
    const Icon(FontAwesomeIcons.swift),
  ];

  List<SkillCards> list = List.generate(
    titles.length,
    (index) => SkillCards(title: titles[index], icon: icons[index]),
  );

  return list;
}
