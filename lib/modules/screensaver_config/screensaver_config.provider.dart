import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';
import 'package:template/modules/screensaver_config/screensaver_config.dart';

final screensaverConfigProvider = PersistentStateProvider(
  store: HiveJsonStore(
    boxName: 'screensaver.config',
    fromJson: (json) => ScreensaverConfig.fromJson(json),
    defaultValue: () => const ScreensaverConfig(),
  ),
);
