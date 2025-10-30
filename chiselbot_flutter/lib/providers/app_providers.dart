import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'qna_provider.dart';

class AppProviders extends InheritedWidget {
  final ApiService api;
  final QnaProvider qna;

  AppProviders({
    super.key,
    required Widget child,
    required String baseUrl,
  })  : api = ApiService(baseUrl),
        qna = QnaProvider(ApiService(baseUrl)),
        super(child: child);

  static AppProviders of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppProviders>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
