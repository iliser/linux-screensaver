import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:template/modules/async_guard_example/async_guard_example.screen.dart';
import 'package:template/modules/examples/auth_network_examples.dart';
import 'package:template/modules/examples/empty.screen.dart';
import 'package:template/modules/examples/example_home.screen.dart';
import 'package:template/modules/examples/examples_list.screen.dart';
import 'package:template/modules/examples/login.screen.dart';
import 'package:template/modules/examples/sse_example.dart';
import 'package:template/modules/http_example/http_error.screen.dart';
import 'package:template/modules/http_example/http_error_navigation.screen.dart';
import 'package:template/modules/screen_saver/screensaver_screen.dart';
import 'package:template/template_modules/components/about_dialog_list_tile.dart';
import 'package:template/template_modules/localization/language_select.dart';
import 'package:template/template_modules/theme/theme_select_list_tile.dart';

import 'template_modules/components/custom_dialog.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    //HomeScreen is generated as HomeRoute because
    //of the replaceInRouteName property
    AutoRoute(
      page: ScreenSaverRoute.page,
      path: '/',
    ),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: ExampleHomeRoute.page, path: '/initial'),
    AutoRoute(
      page: AsyncGuardExampleRoute.page,
      path: '/async_error',
    ),
    AutoRoute(
      page: HttpErrorLayoutRoute.page,
      path: '/http_error',
      children: [
        AutoRoute(
          page: HttpErrorNavigationRoute.page,
          path: '',
        ),
        AutoRoute(
          page: HttpErrorWidgetRoute.page,
          path: 'page/:code',
        ),
        AutoRoute(
          page: HttpErrorRoute.page,
          path: ':code',
        ),
      ],
    ),

    AutoRoute(
      page: EmptyRouteExample.page,
      path: '/empty',
    ),
    AutoRoute(
      page: AsyncEmptyRouteExample.page,
      path: '/async_empty',
    ),
    AutoRoute(
      page: SseRouteExample.page,
      path: '/sse',
    ),
    AutoRoute(
      page: AuthNetworkExamplesRoute.page,
      path: '/auth-network',
    ),
    // routes required by predefined list tiles AboutDialogListTile, ThemeSelectListTile, LanguageSelectListTile
    // also example of transparent route
    CustomRoute(
      opaque: false,
      barrierDismissible: true,
      fullscreenDialog: true,
      transitionsBuilder: CustomDialog.alignedBottomTransitionBuilder,
      page: AboutDialogRoute.page,
      path: '/settings/about',
    ),
    CustomRoute(
      opaque: false,
      barrierDismissible: true,
      fullscreenDialog: true,
      transitionsBuilder: CustomDialog.alignedBottomTransitionBuilder,
      page: LanguageSelectRoute.page,
      path: '/settings/language',
    ),
    CustomRoute(
      opaque: false,
      barrierDismissible: true,
      fullscreenDialog: true,
      transitionsBuilder: CustomDialog.alignedBottomTransitionBuilder,
      page: ThemeSelectRoute.page,
      path: '/settings/theme',
    ),
  ];
}
