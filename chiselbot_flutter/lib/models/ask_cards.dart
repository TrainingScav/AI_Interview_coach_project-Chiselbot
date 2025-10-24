import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AskCards {
  String title;
  Icon icon;
  AskCards({
    required this.title,
    required this.icon,
  });
}

List<AskCards> generateAsk() {
  List<String> titles = [
    "기술",
    "인성",
    "경험",
  ];

  List<Icon> icons = [
    const Icon(FontAwesomeIcons.layerGroup),
    const Icon(FontAwesomeIcons.circleQuestion),
    const Icon(FontAwesomeIcons.comments),
  ];

  List<AskCards> list = List.generate(
    titles.length,
    (index) => AskCards(title: titles[index], icon: icons[index]),
  );

  return list;
}
