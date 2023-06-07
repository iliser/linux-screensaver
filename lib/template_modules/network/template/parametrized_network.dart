import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/template_modules/riverpod_utils.dart';

import 'network_provider_extension.dart';

// class that allow to create parametrized constructor
abstract class ParametrizedNetwork<T> {
  Map<Symbol, AlwaysAliveProviderBase<dynamic>> get args;

  void dispose();
}

class AsyncParametrizedNetworkTag {
  const AsyncParametrizedNetworkTag();
}

class SyncParametrizedNetworkTag {
  const SyncParametrizedNetworkTag();
}

typedef AsyncParametrizedNetworkConstructor<E extends ParametrizedNetwork> = E
    Function({AsyncParametrizedNetworkTag? tag});

typedef SyncParametrizedNetworkConstructor<E extends ParametrizedNetwork> = E
    Function({SyncParametrizedNetworkTag? tag});

// define extension for simplify acces and release watch function,
// then network based providers can be easyly created
extension AsyncParametrizedNetworkProviderExtension<
        Network extends ParametrizedNetwork>
    on AsyncParametrizedNetworkConstructor<Network> {
  Network of(WidgetRef ref) {
    final stub = this();

    return Function.apply(
      this,
      [],
      stub.args.map((key, provider) {
        if (provider is AlwaysAliveProviderBase<AsyncValue>) {
          return MapEntry(key, ref.read(provider).requireValue);
        }
        return MapEntry(key, ref.read(provider));
      }),
    );
  }

  Future<Network> watch(Ref ref) async {
    final stub = this();

    final args = Map.fromEntries(
      await Future.wait(
        stub.args.entries.map((entries) async {
          final provider = entries.value;
          final key = entries.key;

          if (provider is AlwaysAliveProviderBase<AsyncValue>) {
            return MapEntry(key, await ref.watchFuture(provider));
          }
          return MapEntry(key, ref.watch(provider));
        }),
      ),
    );

    final Network network = Function.apply(this, [], args);

    if (ref is AutoDisposeRef) ref.onDispose(network.dispose);

    return network;
  }

  // create future provider that await network and then call function
  NetworkProviderBuilder<Network> get provider => NetworkProviderBuilder(watch);
}

// define extension for simplify acces and release watch function,
// then network based providers can be easyly created
extension SyncParametrizedNetworkProviderExtension<
        Network extends ParametrizedNetwork>
    on SyncParametrizedNetworkConstructor<Network> {
  Network of(WidgetRef ref) {
    final stub = this();

    final args = stub.args.map(
      (key, provider) => MapEntry(key, ref.read(provider)),
    );

    return Function.apply(this, [], args);
  }

  Network watch(Ref ref) {
    final stub = this();

    final args = stub.args.map(
      (key, provider) => MapEntry(key, ref.watch(provider)),
    );

    final Network network = Function.apply(this, [], args);

    if (ref is AutoDisposeRef) {
      ref.onDispose(network.dispose);
    }

    return network;
  }

  // create future provider that await network and then call function
  NetworkProviderBuilder<Network> get provider =>
      NetworkProviderBuilder((ref) async => watch(ref));
}
