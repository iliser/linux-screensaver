import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:template/template_modules/localization/language_provider.dart';
import 'package:template/template_modules/network/network.dart';

// example that show how to add additional dependencies into network class

class LocalizedNetwork extends AuthNetworkBase {
  /// create network with given authorization value
  LocalizedNetwork.value({super.tag, super.authValue, Locale? locale})
      : locale = locale?.toLanguageTag(),
        super.value();

  @override
  get args => {...super.args, #locale: localeProvider};

  final String? locale;

  @visibleForOverriding
  AlwaysAliveProviderBase<Locale?> localeProvider = languageProvider;
}

final localizedRequestProvider =
    LocalizedNetwork.value.provider((ref, net) => () => net.locale);

class Network extends AuthNetworkBase {
  Network.value({super.tag, super.authValue}) : super.value();
}
