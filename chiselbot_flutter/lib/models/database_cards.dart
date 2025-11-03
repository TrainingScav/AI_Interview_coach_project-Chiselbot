import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DatabaseCards {
  String title;
  Icon icon;

  DatabaseCards({
    required this.title,
    required this.icon,
  });
}

List<DatabaseCards> generateDatabase() {
  List<String> titles = [
    "MySQL",
    "PostgreSQL",
  ];

  List<Icon> icons = [
    const Icon(FontAwesomeIcons.database),
    const Icon(FontAwesomeIcons.database),
  ];

  List<DatabaseCards> list = List.generate(
    titles.length,
    (index) => DatabaseCards(title: titles[index], icon: icons[index]),
  );

  return list;
}
