import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optics/optics/optics.dart';

part 'screensaver_config.freezed.dart';
part 'screensaver_config.g.dart';

const List<String> _left = ["BE", "STAY"];
const List<String> _right = ["PERSISTENT", "YOURSELF", "FOCUSED", "PATIENT"];

@freezed
class ScreensaverConfig with _$ScreensaverConfig {
  const ScreensaverConfig._();

  const factory ScreensaverConfig({
    @Default(true) bool showClock,
    @Default(_left) List<String> leftWords,
    @Default(_right) List<String> rightWords,
  }) = _Data;

  factory ScreensaverConfig.fromJson(Map<String, dynamic> json) =>
      _$ScreensaverConfigFromJson(json);
}

extension LinesToString<T> on RiverpodLens<T, List<String>> {
  RiverpodLens<T, String> join(String delimeter) =>
      RiverpodLens.proxy<T, List<String>, String>(
        this,
        (object) => object.join(delimeter),
        (object, updater) => updater(object.join(delimeter)).split(delimeter),
      );
}
