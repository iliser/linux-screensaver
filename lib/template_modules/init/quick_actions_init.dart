import 'dart:developer';

import 'package:quick_actions/quick_actions.dart';

const gQuickActions = QuickActions();
Future quickActionInit() async {
  await gQuickActions.initialize((shortcutType) {
    log('Shortcut type : $shortcutType', name: 'QuickActions');
  });
  await gQuickActions.setShortcutItems([
    // ShortcutItem(
    //   type: 'action_main',
    //   localizedTitle: 'Main view',
    //   icon: 'icon_main',
    // ),
  ]);
}
