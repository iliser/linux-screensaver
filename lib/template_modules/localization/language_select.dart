import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/components/custom_dialog.dart';

import 'language_icon.dart';
import 'language_provider.dart';
import 'language_select_config.dart';

class _LanguageSelectTile extends ConsumerWidget {
  const _LanguageSelectTile(this.locale, {super.key});

  final Locale? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = LanguageSelectListTile.config;
    final language = config.supportedLanguageMap[locale?.languageCode];
    final T = ref.watch(localizationProvider);
    assert(
      locale == null || language != null,
      'Language not registred ${locale?.languageCode}',
    );

    return ListTile(
      onTap: () => ref.read(languageProvider.notifier).update((_) => locale),
      selectedTileColor: config.selectedLanguageColor,
      selected: ref.watch(languageProvider) == locale,
      trailing:
          config.showLanguageFlag ? LanguageIcon(language: language) : null,
      title: Text(language?.name ?? T.systemLanguage),
    );
  }
}

class LanguageSelectListTile extends ConsumerWidget {
  const LanguageSelectListTile({super.key});

  static LanguageSelectConfig config = const LanguageSelectConfig();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final T = ref.watch(localizationProvider);
    final lang = config.supportedLanguageMap[currentLocale?.languageCode];

    assert(
      currentLocale == null || lang != null,
      'Language not registred $currentLocale',
    );

    return ListTile(
      onTap: () => context.router.pushNamed('/settings/language'),
      trailing: config.showLanguageFlag
          ? LanguageIcon(language: lang, alignment: Alignment.centerRight)
          : null,
      subtitle: Text(lang?.name ?? T.systemLanguage),
      title: Text(T.languageSelectTitle),
    );
  }
}

class _LanguageSelectDialog extends ConsumerWidget {
  const _LanguageSelectDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Locale?>[null]
            .followedBy(supportedLocales)
            .map(_LanguageSelectTile.new)
            .toList(),
      ),
    );
  }
}

@RoutePage()
class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomDialogPage(child: _LanguageSelectDialog());
  }
}
