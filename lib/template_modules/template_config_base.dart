// if you need configure app to dev proccess change local_config.dart

import 'package:flutter/foundation.dart';

// need this because DIO don't check base url
String _urlCheck(String url) {
  // this fucking shit just crash app, also assert go through debug
  // i dunno how it's just happen
  // spend 3+ hour on this shit
  if (RegExp('https?://').hasMatch(url)) {
    return url;
  }
  throw Exception("Base url does't contain http");
}

abstract class TemplateConfigBase {
  TemplateConfigBase();

  @nonVirtual
  String get baseImageUrl => _urlCheck(getBaseImageUrl);
  @nonVirtual
  String get baseApiUrl => _urlCheck(getBaseApiUrl);

  @protected
  String get getBaseApiUrl;

  @protected
  String get getBaseImageUrl;

  bool get enableSentry;
  bool get enableNetworkPerformance;

  String get sentryDsn;
  double? get sentryTransactionSampleRate;
  double? get sentrySampleRate;

  String get onesignalAppId;

  Duration get defaultAnimationDuration => const Duration(milliseconds: 150);

  // Init automaticly
  late final String applicationSupportDirectory;

  String? get onesignalDefaultExternalUserId;
}
