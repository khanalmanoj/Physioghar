import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_strings.dart';

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.en);

  void toggleLanguage() {
    state = state == AppLanguage.en ? AppLanguage.ne : AppLanguage.en;
  }

  void setLanguage(AppLanguage language) {
    state = language;
  }
}

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

extension LocalizedBuildContext on BuildContext {
  String tr(String key) {
    final container = ProviderScope.containerOf(this, listen: false);
    final lang = container.read(languageNotifierProvider);
    return AppStrings.get(key, lang);
  }
}
