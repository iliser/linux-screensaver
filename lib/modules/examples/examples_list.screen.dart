import 'package:async_button_builder/async_button_builder.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/modules/http_example/http_error.screen.dart';
import 'package:template/template_modules/components/about_dialog_list_tile.dart';
import 'package:template/template_modules/localization/language_select.dart';
import 'package:template/template_modules/network/network.dart';

import 'package:template/template_modules/theme/theme_select_list_tile.dart';

@RoutePage()
class ExamplesListScreen extends ConsumerWidget {
  const ExamplesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const ThemeSelectListTile(),
            const LanguageSelectListTile(),
            const AboutDialogListTile(),
            ListTile(
              onTap: () => context.router.pushNamed('/empty'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Empty'),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/async_empty'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Async Empty'),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/http_error'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Http errors'),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/async_error'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('AsyncGuard'),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/async_error?error=error'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('AsyncGuard Error'),
            ),
            AsyncButtonBuilder(
              child: const SizedBox.shrink(),
              onPressed: () => HttpCodeNetwork.value.of(ref).getResult('404'),
              builder: (context, child, cb, state) => ListTile(
                onTap: cb,
                title: const Text('Http 404 in callback'),
                trailing: child,
              ),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/initial'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('authorization'),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/sse'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('sse events'),
            ),
            ListTile(
              onTap: () => context.router.pushNamed('/auth-network'),
              trailing: const Icon(Icons.navigate_next),
              title: const Text('Auth network examples'),
            ),
          ],
        ),
      ),
    );
  }
}
