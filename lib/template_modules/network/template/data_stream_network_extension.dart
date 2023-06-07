import 'package:riverpod/riverpod.dart';

import 'parametrized_network.dart';

extension DataStreamAsyncNetworkExtension<Network extends ParametrizedNetwork>
    on AsyncParametrizedNetworkConstructor<Network> {
  DataStreamProviderBuilder<Network> get dataStream =>
      DataStreamProviderBuilder(watch);
}

extension DataStreamNetworkExtension<Network extends ParametrizedNetwork>
    on SyncParametrizedNetworkConstructor<Network> {
  DataStreamProviderBuilder<Network> get dataStream =>
      DataStreamProviderBuilder((ref) async => watch(ref));
}

class DataStreamProviderBuilder<Network extends ParametrizedNetwork> {
  DataStreamProviderBuilder(this._watch);

  final Future<Network> Function(Ref ref) _watch;

  AutoDisposeStateProvider<Stream<Res> Function()> call<Res>(
    Stream<Res> Function() Function(Ref ref, Network net) create,
  ) {
    return AutoDisposeStateProvider((ref) {
      final network = _watch(ref);
      return () {
        return network
            .then((value) => create(ref, value))
            .asStream()
            .asyncExpand((e) => e());
      };
    });
  }

  DataStreamProviderFamilyBuilder<Network> get family =>
      DataStreamProviderFamilyBuilder<Network>(_watch);
}

class DataStreamProviderFamilyBuilder<Network extends ParametrizedNetwork> {
  DataStreamProviderFamilyBuilder(this._watch);

  final Future<Network> Function(Ref ref) _watch;

  AutoDisposeStateProviderFamily<Stream<Res> Function(), Arg> call<Res, Arg>(
    Stream<Res> Function(Arg arg) Function(Ref ref, Network net) create,
  ) {
    return AutoDisposeStateProviderFamily((ref, Arg arg) {
      final network = _watch(ref);
      return () {
        return network
            .then((value) => create(ref, value))
            .asStream()
            .asyncExpand((e) => e(arg));
      };
    });
  }
}
