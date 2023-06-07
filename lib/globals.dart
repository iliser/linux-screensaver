import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:template/router.dart';

import 'config/local_config.dart';
import 'config/production_config.dart';

export 'package:template/template_modules/localization/language_provider.dart'
    show localizationProvider, staticLocalization, supportedLocales;

export 'package:template/template_modules//init/quick_actions_init.dart'
    show gQuickActions;

final config = kDebugMode ? LocalConfig() : ProductionConfig();

final gScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final gAppRouter = AppRouter();

bool showDebugBanner = true;
