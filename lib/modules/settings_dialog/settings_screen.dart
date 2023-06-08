import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
            // SwitchListTile(
            //   onChanged: (_) {},
            //   value: true,
            //   title: Text('Show clock'),
            // ),
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
