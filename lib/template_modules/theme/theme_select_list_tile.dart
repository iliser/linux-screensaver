import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:template/template_modules/components/custom_dialog.dart';
import 'package:template/globals.dart';
import 'package:template/themes/themes.dart';

import 'application_theme.dart';
import 'theme_provider.dart';

class ThemeSelectListTile extends ConsumerWidget {
  const ThemeSelectListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);
    return ListTile(
      title: Text(T.theme.chageThemeTitle),
      trailing: const Icon(Icons.brightness_6),
      onTap: () => context.router.pushNamed('/settings/theme'),
    );
  }
}

class _ThemeListTile extends ConsumerWidget {
  const _ThemeListTile(this.theme);

  final ApplicationTheme theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = theme.getThemeData(context);
    final selected = ref.watch(themeProvider).id == theme.id;
    final title = theme.getTitle();
    final subtitle = theme.getSubtitle();
    final icon = theme.getIcon();

    return Theme(
      data: themeData,
      child: Material(
        child: ListTile(
          selected: selected,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title),
              const SizedBox(width: 4),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? themeData.toggleableActiveColor
                          : themeData.hintColor,
                    ),
                  ),
                ),
            ],
          ),
          trailing: icon,
          onTap: () =>
              ref.read(themeProvider.notifier).update((state) => theme),
        ),
      ),
    );
  }
}

class _ThemeSelectDialog extends ConsumerWidget {
  const _ThemeSelectDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: applicationThemes.map(_ThemeListTile.new).toList(),
        ),
      ),
    );
  }
}

@RoutePage()
class ThemeSelectScreen extends StatelessWidget {
  const ThemeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomDialogPage(child: _ThemeSelectDialog());
  }
}
