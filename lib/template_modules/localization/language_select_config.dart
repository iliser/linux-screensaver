import 'package:flutter/rendering.dart';

class Language {
  const Language(this.countryCode, this.name);

  final String countryCode;
  final String name;
}

class LanguageSelectConfig {
  const LanguageSelectConfig([
    this.showLanguageFlag = true,
    this.supportedLanguageMap = const {
      'ru': Language('ru', 'Русский'),
      'en': Language('us', 'English'),
    },
    this.selectHeaderColor,
    this.selectedLanguageColor,
  ]);

  final Map<String, Language> supportedLanguageMap;
  final bool showLanguageFlag;
  final Color? selectHeaderColor;
  final Color? selectedLanguageColor;
}
