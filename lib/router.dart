import 'package:auto_route/auto_route.dart';
import 'package:template/modules/screen_saver/screensaver_screen.dart';
import 'package:template/modules/settings_dialog/settings_screen.dart';
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
    // routes required by predefined list tiles AboutDialogListTile, ThemeSelectListTile, LanguageSelectListTile
    // also example of transparent route
    CustomRoute(
      opaque: false,
      barrierDismissible: true,
      fullscreenDialog: true,
      transitionsBuilder: CustomDialog.alignedBottomTransitionBuilder,
      page: SettingsRoute.page,
      path: '/settings',
    ),
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
