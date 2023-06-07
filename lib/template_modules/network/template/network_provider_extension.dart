import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import 'parametrized_network.dart';

class NetworkProviderBuilder<Network extends ParametrizedNetwork> {
  const NetworkProviderBuilder(this._watch);

  final Future<Network> Function(Ref ref) _watch;

  FutureProvider<Res> call<Res>(
    FutureOr<Res> Function() Function(Ref ref, Network net) fn,
  ) =>
      FutureProvider((ref) => _watch(ref).then((v) => fn(ref, v)()));

  NetworkProviderFamilyBuilder<Network> get family =>
      NetworkProviderFamilyBuilder<Network>(_watch);

  NetworkProviderAutoDisposeBuilder<Network> get autoDispose =>
      NetworkProviderAutoDisposeBuilder<Network>(_watch);
}

class NetworkProviderAutoDisposeBuilder<Network extends ParametrizedNetwork> {
  const NetworkProviderAutoDisposeBuilder(this._watch);

  final Future<Network> Function(Ref ref) _watch;

  AutoDisposeFutureProvider<Res> call<Res>(
    FutureOr<Res> Function() Function(Ref ref, Network net) fn,
  ) =>
      FutureProvider.autoDispose(
        (ref) => _watch(ref).then((v) => fn(ref, v)()),
      );
}

class NetworkProviderFamilyBuilder<Network extends ParametrizedNetwork> {
  const NetworkProviderFamilyBuilder(this._watch);
  final Future<Network> Function(Ref ref) _watch;

  FutureProviderFamily<Res, Arg> call<Res, Arg>(
    FutureOr<Res> Function(Arg arg) Function(Ref ref, Network net) fn,
  ) =>
      FutureProvider.family(
        (ref, Arg arg) => _watch(ref).then((n) => fn(ref, n)(arg)),
      );

  NetworkProviderFamilyAutoDisposeBuilder<Network> get autoDispose =>
      NetworkProviderFamilyAutoDisposeBuilder<Network>(_watch);
}

class NetworkProviderFamilyAutoDisposeBuilder<
    Network extends ParametrizedNetwork> {
  const NetworkProviderFamilyAutoDisposeBuilder(this._watch);
  final Future<Network> Function(Ref ref) _watch;

  AutoDisposeFutureProviderFamily<Res, Arg> call<Res, Arg>(
    FutureOr<Res> Function(Arg arg) Function(Ref ref, Network net) fn,
  ) =>
      FutureProvider.family.autoDispose(
        (ref, Arg arg) => _watch(ref).then((n) => fn(ref, n)(arg)),
      );
}
