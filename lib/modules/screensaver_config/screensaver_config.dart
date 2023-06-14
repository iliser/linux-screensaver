import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optics/optics/optics.dart';
import 'package:rxdart/rxdart.dart';

part 'screensaver_config.freezed.dart';
part 'screensaver_config.g.dart';

const List<String> _left = ["BE", "STAY"];
const List<String> _right = ["PERSISTENT", "YOURSELF", "FOCUSED", "PATIENT"];

@freezed
class ScreensaverConfig
    with _$ScreensaverConfig
    implements LensReflect<ScreensaverConfig> {
  const ScreensaverConfig._();

  const factory ScreensaverConfig({
    @Default(true) bool showClock,
    @Default(_left) List<String> leftWords,
    @Default(_right) List<String> rightWords,
  }) = _Data;

  factory ScreensaverConfig.fromJson(Map<String, dynamic> json) =>
      _$ScreensaverConfigFromJson(json);

  @override
  dynamic getField(Symbol name) => switch (name) {
        #showClock => showClock,
        #leftWords => leftWords,
        #rightWords => rightWords,
        _ => throw '',
      };
}

extension LinesToString<T> on RiverpodLens<T, List<String>> {
  RiverpodLens<T, String> join(String delimeter) =>
      RiverpodLens.proxy<T, List<String>, String>(
        this,
        (object) => object.join(delimeter),
        (object, updater) => updater(object.join(delimeter)).split(delimeter),
      );
}
