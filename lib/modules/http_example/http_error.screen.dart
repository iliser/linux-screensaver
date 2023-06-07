import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guarded_core/configuration/guarded_configuration.dart';
import 'package:template/template_modules/guards/guard.dart';
import 'package:template/template_modules/guards/guards/guarded_http_error.dart';

import 'package:template/template_modules/network/error/connection_exception.dart';
import 'package:template/template_modules/network/network.dart';

class HttpCodeNetwork extends NetworkBase {
  HttpCodeNetwork.value({SyncParametrizedNetworkTag? tag});

  Future<String> getResult(String code) async {
    final exmap = {
      'Send': SendTimeoutException(Uri()),
      'Recieve': RecieveTimeoutException(Uri()),
      'Connection': ConnectionTimeoutException(Uri()),
      'Socket': SocketException(Uri()),
      'Generic': 'wtf is going on',
    };

    if (exmap[code] != null) throw exmap[code]!;

    final ans = await dio.get(
      'https://mock.codes/$code',
      cancelToken: disposeToken,
    );

    return ans.data['description'];
  }
}

final httpErrorProvider = HttpCodeNetwork.value.provider.family
    .autoDispose((ref, network) => network.getResult);

@RoutePage()
class HttpErrorScreen extends GuardedScreen {
  const HttpErrorScreen(@PathParam() this.code, {Key? key}) : super(key: key);

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Http error test')),
      body: const SafeArea(
        child: Center(
          child: Text('All is fine'),
        ),
      ),
    );
  }

  @override
  List<ScreenGuard> get guards => [
        HttpGuard(httpErrorProvider(code)),
      ];
}

@RoutePage()
class HttpErrorWidgetScreen extends StatelessWidget {
  const HttpErrorWidgetScreen(@PathParam() this.code, {Key? key})
      : super(key: key);

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Http Error Page Screen')),
      body: _HttpErrorWidget(code),
    );
  }
}

class _HttpErrorWidget extends GuardedWidget {
  const _HttpErrorWidget(this.code, {Key? key}) : super(key: key);

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(child: Text('All is fine'));
  }

  @override
  Iterable<GuardedConfiguration> get rawConfiguration => [
        ...super.rawConfiguration,
        HttpGuard.httpErrorBuilder(HttpCatErrorWidget.new),
      ];
  @override
  List<WidgetGuard> get guards => [
        HttpGuard(httpErrorProvider(code)),
      ];
}
