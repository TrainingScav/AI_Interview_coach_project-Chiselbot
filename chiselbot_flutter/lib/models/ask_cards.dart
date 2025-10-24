class AskCards {
  String? title, img;
  AskCards({
    required this.title,
    required this.img,
  });
}

List<AskCards> generateData() {
  List<String> titles = [
    "Java",
    "Python",
    "Flutter",
  ];

  List<String> imgUrl = [
    "https://img.icons8.com/color/48/java-coffee-cup-logo--v1.png",
    "https://img.icons8.com/color/48/python--v1.png",
    "https://img.icons8.com/color/48/flutter.png",
  ];

  List<AskCards> list = List.generate(
    3,
    (index) => AskCards(
      title: titles[index],
      img: imgUrl[index],
    ),
  );

  return list;
}
