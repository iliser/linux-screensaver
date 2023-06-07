import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/modules/examples/localized_network.example.dart';
import 'package:template/template_modules/global_authorization_module.dart';
import 'package:template/template_modules/network/network.dart';

class TestNetwork extends AuthNetworkBase {
  /// use cases:
  ///  `Network.value.provider((net) => net.fetchData)`
  ///  `Network.value.provider((net) => () =>  net.fetchDataWithArg("42"))`
  ///  `Network.value.provider.autoDispose((net) => net.fetchData)`
  ///  `Network.value.provider.family((net) => (String arg) =>  net.fetchDataWithArg(arg))`
  ///  `Network.value.provider.family((net) => net.fetchDataWithArg)`
  ///  `Network.value.provider.family.autoDispose((net) => net.fetchDataWithArg)`
  ///
  /// create network with given authorization value
  TestNetwork.value({
    AsyncParametrizedNetworkTag? tag,
    AuthorizationValue authValue = const AuthorizationValue.unauthorized(),
  }) : super.value(authValue: authValue);

  Future<String> request() async => authorizationValue.toString();
  Future<String> argumentRequest(String argument) async =>
      'token = ${authorizationValue.toString()} , argument = $argument';
}

final req = FutureProvider(
  (ref) => TestNetwork.value.watch(ref).then((v) => v.request()),
);

final requestProvider =
    TestNetwork.value.provider((ref, network) => network.request);

final argumentRequestProvider = TestNetwork.value.provider
    .family((ref, network) => network.argumentRequest);

@RoutePage()
class AuthNetworkExamplesScreen extends ConsumerWidget {
  const AuthNetworkExamplesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth network request')),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              onTap: () => ref
                  .read(AuthorizationModule.globalTokenProvider.notifier)
                  .update(
                    (value) => value == const AuthorizationValue.unauthorized()
                        ? const AuthorizationValue.bearer('token')
                        : const AuthorizationValue.unauthorized(),
                  ),
              trailing: const Icon(Icons.swap_horiz),
              title: const Text('Toggle token'),
            ),
            ListTile(
              title: const Text('Network request'),
              subtitle: Text(ref.watch(requestProvider).toString()),
            ),
            ListTile(
              title: const Text('Network argument request'),
              subtitle: Text(
                ref.watch(argumentRequestProvider("42")).toString(),
              ),
            ),
            ListTile(
              title: const Text('Localized network request '),
              subtitle: Text(ref.watch(localizedRequestProvider).toString()),
            )
          ],
        ),
      ),
    );
  }
}
