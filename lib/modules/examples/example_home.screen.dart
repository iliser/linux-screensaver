import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliver_stream_builder/sliver_stream_builder.dart';
import 'package:template/template_modules/global_authorization_module.dart';
import 'package:template/template_modules/guards/guard.dart';
import 'package:template/template_modules/network/network.dart';

class _Network extends AuthNetworkBase {
  _Network.value({
    super.tag,
    super.authValue,
  }) : super.value();

  Stream<int> ids() {
    return dataStreamHelper.state(0).next((it) async {
      dev.log('Fetch', name: 'stream');
      final i = it.current;
      if (i % 10 == 0) await Future.delayed(const Duration(milliseconds: 600));
      if (i % 5 == 0 && Random().nextDouble() < 0.3) {
        // throw 'err';
      }

      return it.next([i], it.current + 1);
    });
  }
}

final idsProvider = _Network.value.dataStream((ref, net) => net.ids);

// ProductsNetwork.value.provider.autoDispose((net) => net.productIds);

class _HomeScreenCard extends StatelessWidget {
  const _HomeScreenCard(this.index, {Key? key}) : super(key: key);

  static double minWidth = 100;
  final int index;

  static _HomeScreenCard fromInt(int id) => _HomeScreenCard(id);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(index.toString()),
            ),
          ),
        ),
      ),
    );
  }
}

@RoutePage()
class ExampleHomeScreen extends GuardedScreen {
  const ExampleHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elementsInRow =
        (MediaQuery.of(context).size.width / (_HomeScreenCard.minWidth))
            .floor();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthorizationModule.logout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverStreamBuilder(
              stream: ref
                  .watch(idsProvider)()
                  .doOnResume(() => dev.log('Resume', name: 'stream'))
                  .doOnPause(() => dev.log('Pause', name: 'stream'))
                  .bufferCount(elementsInRow),
              builder: (ctx, List<int> v) => Row(
                children: v.map(_HomeScreenCard.fromInt).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  List<ScreenGuard> get guards => [AuthorizationGuard.logout()];
}
