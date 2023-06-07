import 'application_config_base.dart';

class DebugConfig extends ApplicationConfigBase {
  @override
  String get getBaseApiUrl => 'http://localhost:3000';

  @override
  String get getBaseImageUrl => 'http://localhost:3000';

  @override
  bool get enableSentry => false;
  @override
  bool get enableNetworkPerformance => false;

  @override
  String get sentryDsn =>
      'https://c53ec0b1488b4377aa2218194403244a@o418537.ingest.sentry.io/5658563';

  @override
  double? get sentryTransactionSampleRate => null;

  @override
  double? get sentrySampleRate => 1.0;

  @override
  String get onesignalAppId => '7e1a870f-f5d7-4df4-b538-fb742b5ed505';

  @override
  String? get onesignalDefaultExternalUserId => null;
}
