import 'package:optics/optics/optics.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';
import 'package:template/modules/screensaver_config/screensaver_config.dart';

final screensaverConfigProvider = PersistentStateProvider(
  store: HiveJsonStore(
    boxName: 'screensaver.config',
    fromJson: (json) => ScreensaverConfig.fromJson(json),
    defaultValue: () => const ScreensaverConfig(),
  ),
);

extension ScreensaverConfigLenses<T> on RiverpodLens<T, ScreensaverConfig> {
  RiverpodLens<T, bool> get showClock =>
      proxyBySymbol(#showClock, (v) => v.showClock);
  RiverpodLens<T, List<String>> get leftWords =>
      proxyBySymbol(#leftWords, (v) => v.leftWords);
  RiverpodLens<T, List<String>> get rightWords =>
      proxyBySymbol(#rightWords, (v) => v.rightWords);
}
