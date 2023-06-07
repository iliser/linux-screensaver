// if you need configure app to dev proccess change local_config.dart

import 'application_config_base.dart';

class ProductionConfig extends ApplicationConfigBase {
  @override
  String get getBaseApiUrl => 'htpps://example.com';

  @override
  String get getBaseImageUrl => 'htpps://example.com';

  @override
  bool get enableSentry => true;

  @override
  bool get enableNetworkPerformance => false;

  @override
  String get sentryDsn =>
      'https://6ae29fd2c53d40e89580c3f9b1f4ba35@o418537.ingest.sentry.io/4505320026800128';
  @override
  double? get sentrySampleRate => 1.0;

  @override
  double? get sentryTransactionSampleRate => 1.0;

  @override
  String get onesignalAppId => '';

  @override
  String? get onesignalDefaultExternalUserId => null;
}
