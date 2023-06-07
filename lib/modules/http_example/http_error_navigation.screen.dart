import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HttpErrorNavigationScreen extends StatelessWidget {
  const HttpErrorNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => AutoRouter.of(context).pop(),
        ),
        title: const Text('Navigate to Http error'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ...[
              '400',
              '401',
              '403',
              '404',
              '405',
              '422',
              '429',
              '500',
              '503',
              'Send',
              'Recieve',
              'Connection',
              'Socket',
              'Generic'
            ]
                .map(
                  (e) => [
                    ListTile(
                      onTap: () => context.router.navigateNamed(e),
                      trailing: const Icon(Icons.navigate_next),
                      title: Text(e),
                    ),
                    ListTile(
                      onTap: () => context.router.navigateNamed("page/$e"),
                      trailing: const Icon(Icons.navigate_next),
                      title: Text("Page: $e"),
                    )
                  ],
                )
                .expand((e) => e),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class HttpErrorLayoutScreen extends StatelessWidget {
  const HttpErrorLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
