import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/enhanced_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLanguageSection(context, l10n, ref),
          const SizedBox(height: 24),
          // Future settings sections can be added here
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLanguageSelector(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentLanguageCode = currentLocale?.languageCode ?? 'en';
    
    return Column(
      children: [
        _buildLanguageOption(
          context,
          'English',
          'en',
          '🇺🇸',
          currentLanguageCode,
          ref,
        ),
        _buildLanguageOption(
          context,
          'Español',
          'es',
          '🇪🇸',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          '中文',
          'zh',
          '🇨🇳',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Português',
          'pt',
          '🇵🇹',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Français',
          'fr',
          '🇫🇷',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'हिन्दी',
          'hi',
          '🇮🇳',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Bahasa Melayu',
          'ms',
          '🇲🇾',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'ไทย',
          'th',
          '🇹🇭',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Filipino',
          'fil',
          '🇵🇭',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          '日本語',
          'ja',
          '🇯🇵',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Tiếng Việt',
          'vi',
          '🇻🇳',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          '한국어',
          'ko',
          '🇰🇷',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Italiano',
          'it',
          '🇮🇹',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'Deutsch',
          'de',
          '🇩🇪',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
        _buildLanguageOption(
          context,
          'العربية',
          'ar',
          '🇸🇦',
          currentLocale?.languageCode ?? 'en',
          ref,
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    String flag,
    String currentLanguageCode,
    WidgetRef ref,
  ) {
    final isSelected = currentLanguageCode == languageCode;
    
    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(languageName),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      selected: isSelected,
      onTap: () async {
        // Use the StateNotifier's setLocale method
        await ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to $languageName'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(
                bottom: 80,
                left: 16,
                right: 16,
              ),
            ),
          );
        }
      },
    );
  }
}