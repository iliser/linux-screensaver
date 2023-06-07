import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';
import 'package:template/template_modules/network/network.dart';

class NetNetwork extends NetworkBase {
  NetNetwork.value({AsyncParametrizedNetworkTag? tag}) : super.value();

  @override
  Duration? get recieveTimeout => null;

  Stream<SseEvent> connectSse() {
    return dio.getSse('https://sse.dev/test', cancelToken: disposeToken);
  }

  @override
  Map<Symbol, AlwaysAliveProviderBase> get args => {};
}

final sseStream = Provider.autoDispose(
  (ref) => () async* {
    final net = await NetNetwork.value.watch(ref);

    yield* net.connectSse();
  },
);

@RoutePage()
class SseScreenExample extends ConsumerWidget {
  const SseScreenExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder<SseEvent>(
              stream: ref.watch(sseStream)(),
              builder: (context, event) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    const JsonEncoder.withIndent('    ')
                        .convert(jsonDecode(event.data)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
