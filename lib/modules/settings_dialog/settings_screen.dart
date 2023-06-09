import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optics/optics/optics.dart';
import 'package:template/globals.dart';
import 'package:template/modules/screensaver_config/screensaver_config.dart';
import 'package:template/modules/screensaver_config/screensaver_config.provider.dart';
import 'package:template/router.dart';
import 'package:template/template_modules/components/about_dialog_list_tile.dart';
import 'package:template/template_modules/components/custom_dialog.dart';
import 'package:template/template_modules/theme/theme_select_list_tile.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomDialogPage(
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WordListListTile(),
            _ShowClockListTile(),
            // ListTile(
            //   title: Text('Word change delay'),
            // ),
            // ListTile(
            //   title: Text('word list'),
            //   trailing: Icon(Icons.text_fields_sharp),
            // ),
            // LanguageSelectListTile(),
            ThemeSelectListTile(),
            AboutDialogListTile(),
          ],
        ),
      ),
    );
  }
}

class _ShowClockListTile extends ConsumerWidget {
  const _ShowClockListTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localizationProvider);

    final r = screensaverConfigProvider.lens.leftWords.join;

    return SwitchListTileL(
      lens: screensaverConfigProvider.lens.showClock,
      title: Text(t.settings.showClock),
    );
  }
}

class _WordListListTile extends ConsumerWidget {
  const _WordListListTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localizationProvider);
    return ListTile(
      title: Text(t.settings.editWordsListTile),
      trailing: const Icon(Icons.navigate_next),
      onTap: () => context.router.push(const WordListSettingsRoute()),
    );
  }
}
