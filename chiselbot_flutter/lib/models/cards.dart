import 'package:flutter/material.dart';

import 'ask_cards.dart';
import 'skill_cards.dart';
import 'backend_cards.dart';
import 'frontend_cards.dart';
import 'database_cards.dart';

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

class BackendCardData implements CardData {
  final BackendCards _backendCard;

  BackendCardData(this._backendCard);

  @override
  String get title => _backendCard.title;

  @override
  Widget get icon => _backendCard.icon;
}

class FrontendCardData implements CardData {
  final FrontendCards _frontendCard;

  FrontendCardData(this._frontendCard);

  @override
  String get title => _frontendCard.title;

  @override
  Widget get icon => _frontendCard.icon;
}

class DatabaseCardData implements CardData {
  final DatabaseCards _databaseCard;

  DatabaseCardData(this._databaseCard);

  @override
  String get title => _databaseCard.title;

  @override
  Widget get icon => _databaseCard.icon;
}

class CardDataFactory {
  static List<CardData> createAskCards() {
    return generateAsk().map((ask) => AskCardData(ask)).toList();
  }

  static List<CardData> createSkillCards() {
    return generateSkill().map((skill) => SkillCardData(skill)).toList();
  }

  static List<CardData> createBackendCards() {
    return generateBackend()
        .map((backend) => BackendCardData(backend))
        .toList();
  }

  static List<CardData> createFrontendCards() {
    return generateFrontend()
        .map((frontend) => FrontendCardData(frontend))
        .toList();
  }

  static List<CardData> createDatabaseCards() {
    return generateDatabase()
        .map((database) => DatabaseCardData(database))
        .toList();
  }
}
