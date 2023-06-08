import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:template/globals.dart';
import 'package:template/template_modules/init/hive_init.dart';
import 'package:template/template_modules/init/onesignal_init.dart';
import 'package:template/template_modules/init/quick_actions_init.dart';
import 'package:template/template_modules/init/sentry_init.dart';
import 'package:template/template_modules/theme/theme_provider.dart';
import 'package:template/template_modules/update.dart';
import 'package:the_splash/splash_screen.dart';
import 'package:the_splash/the_splash.dart';
import 'package:window_manager/window_manager.dart';

import 'template_modules/localization/language_provider.dart';

// export for screenshot capture
export 'globals.dart' show gAppRouter, showDebugBanner;

// TODO configure app signing

// TODO https://flutter.dev/docs/development/ui/navigation/deep-linking#enable-deep-linking-on-ios
// TODO add ios deep links
// https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html?utm_source=revxblog
// https://appvesto.medium.com/flutter-deep-links-ios-universal-links-and-android-app-links-8207eea694fb

// TODO android add app link verification
void main() async {
  await SentryFlutter.init(
    sentryOptionsInit,
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Must add this line.
      await windowManager.ensureInitialized();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);

      config.applicationSupportDirectory =
          await getApplicationSupportDirectory().then((e) => e.path);
      // initialize hive out of order for speed up sync provider initialization
      await hiveInit();

      await Future.wait([
        // onesignalInit(),
        // quickActionInit(),
        SplashScreenData.preload(),
        // place for initialize PersistentSyncedStateProviders
        themeProvider.awaitInitialized(),
        languageProvider.awaitInitialized(),
      ]);

      WindowOptions windowOptions = const WindowOptions(
        fullScreen: true,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );

      await windowManager.waitUntilReadyToShow(windowOptions);

      SentryFlutter.setAppStartEnd(DateTime.now());

      runApp(const ApplicationWidget());
    },
  );
}

// additional widget to not rebuild ProviderScope on locale changes
class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _RouterWidget());
  }
}

class _RouterWidget extends ConsumerStatefulWidget {
  const _RouterWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RouterWidgetState();
}

class _RouterWidgetState extends ConsumerState<_RouterWidget> {
  @override
  void initState() {
    // wait first frame and then display window
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await windowManager.show();
      await windowManager.focus();
    });
    checkUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: showDebugBanner,
      locale: locale,
      scaffoldMessengerKey: gScaffoldMessengerKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      title: '@Template.ApplicationName',
      themeMode: theme.themeMode,
      theme: theme.lightData,
      darkTheme: theme.darkData,
      routerDelegate: gAppRouter.delegate(
        placeholder: (context) => const SplashScreen(),
        navigatorObservers: () => [SentryNavigatorObserver()],
      ),
      routeInformationParser: gAppRouter.defaultRouteParser(),
    );
  }
}
