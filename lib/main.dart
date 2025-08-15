import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'config/theme_config.dart';
import 'screens/main_navigation_screen.dart';
import 'l10n/app_localizations.dart';
import 'providers/providers.dart';

void main() {
  // Initialize SQLite for desktop/web platforms
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  runApp(
    const ProviderScope(
      child: PickleizerApp(),
    ),
  );
}

class PickleizerApp extends ConsumerWidget {
  const PickleizerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Pickleizer',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('zh'), // Chinese
        Locale('pt'), // Portuguese
        Locale('fr'), // French
        Locale('hi'), // Hindi
        Locale('ms'), // Malay
        Locale('th'), // Thai
        Locale('fil'), // Filipino
        Locale('ja'), // Japanese
        Locale('vi'), // Vietnamese
        Locale('ko'), // Korean
        Locale('it'), // Italian
        Locale('de'), // German
        Locale('ar'), // Arabic
      ],
      home: const MainNavigationScreen(),
    );
  }
}