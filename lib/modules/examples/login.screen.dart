import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/global_authorization_module.dart';
import 'package:template/globals.dart';
import 'package:template/template_modules/localization/language_select.dart';
import 'package:template/template_modules/network/error/http_exception.dart';
import 'package:template/template_modules/network/template/authorization_value.dart';

@RoutePage()
class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref
              .watch(AuthorizationModule.globalTokenProvider)
              .maybeWhen(data: (v) => v, orElse: () => null)
              .toString(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              title: const Text('Forbiden'),
              onTap: () => throw ForbidenException.fromResponse(
                Response(requestOptions: RequestOptions(path: 'http://hello')),
                '',
              ),
            ),
            const LanguageSelectListTile(),
            // locatlization in const widget does't change properly, cause const
            // widget don't rebuild, and localization get from first build
            const _Widget(),
            // ignore: prefer_const_constructors
            _Widget(),
            Center(
              child: TextButton(
                onPressed: () async {
                  final router = context.router;
                  await AuthorizationModule.updateToken(
                    ref,
                    const AuthorizationValue.bearer('token'),
                  );

                  router.popUntilRoot();
                  await router.replaceNamed('/');
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Widget extends ConsumerWidget {
  const _Widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final T = ref.watch(localizationProvider);
    return Center(
      child: Text(T.helloWorld),
    );
  }
}
