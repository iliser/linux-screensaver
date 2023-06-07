// if you need configure app to dev proccess change local_config.dart

import 'application_config_base.dart';

class ProductionConfig extends ApplicationConfigBase {
  @override
  String get getBaseApiUrl;

  @override
  String get getBaseImageUrl;

  @override
  bool get enableSentry => true;
  @override
  bool get enableNetworkPerformance => false;

  @override
  String get sentryDsn;
  @override
  String get onesignalAppId;
}
