import 'package:freezed_annotation/freezed_annotation.dart';

part 'screensaver_config.freezed.dart';
part 'screensaver_config.g.dart';

@freezed
class ScreensaverConfig with _$ScreensaverConfig {
  const ScreensaverConfig._();

  const factory ScreensaverConfig({
    @Default(true) bool showClock,
  }) = _Data;

  factory ScreensaverConfig.fromJson(Map<String, dynamic> json) =>
      _$ScreensaverConfigFromJson(json);
}
