import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/app_language_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PhysioGharApp()));
}

class PhysioGharApp extends ConsumerWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageNotifierProvider);

    return MaterialApp(
      title: 'PhysioGhar Therapist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: Locale(currentLanguage.name),
      home: const MainNavigationScreen(),
    );
  }
}
