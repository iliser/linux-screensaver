import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/globals.dart';
import 'package:template/modules/screensaver_config/screensaver_config.provider.dart';
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
  const _ShowClockListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localizationProvider);
    return SwitchListTile(
      value:
          ref.watch(screensaverConfigProvider).valueOrNull?.showClock ?? false,
      onChanged: (v) => ref
          .read(screensaverConfigProvider.notifier)
          .update((value) => value.copyWith(showClock: v)),
      title: Text(t.settings.showClock),
    );
  }
}
