import 'package:flutter/material.dart';

import 'ask_cards.dart';
import 'skill_cards.dart';

abstract class CardData {
  String get title;

  Widget get icon;
}

class AskCardData implements CardData {
  final AskCards _askCard;

  AskCardData(this._askCard);

  @override
  String get title => _askCard.title;

  @override
  Widget get icon => _askCard.icon;
}

class SkillCardData implements CardData {
  final SkillCards _skillCard;

  SkillCardData(this._skillCard);

  @override
  String get title => _skillCard.title;

  @override
  Widget get icon => _skillCard.icon;
}

class CardDataFactory {
  static List<CardData> createAskCards() {
    return generateAsk().map((ask) => AskCardData(ask)).toList();
  }

  static List<CardData> createSkillCards() {
    return generateSkill().map((skill) => SkillCardData(skill)).toList();
  }
}
