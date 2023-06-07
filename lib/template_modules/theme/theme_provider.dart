import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';
import 'package:template/themes/themes.dart';

import 'application_theme.dart';

final themeProvider = PersistentSyncedStateProvider<ApplicationTheme>(
  store: HiveStringStore(
    defaultValue: () => applicationThemes[0],
    decode: (v) => applicationThemes.firstWhere(
      (e) => e.id == v,
      orElse: () => applicationThemes[0],
    ),
    encode: (v) => v.id,
    boxName: 'selected_theme',
  ),
);
