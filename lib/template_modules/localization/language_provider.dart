import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_persistent_state/riverpod_persistent_state.dart';
import 'package:template/i18n/strings.g.dart';

// null is system locale
final languageProvider = PersistentSyncedStateProvider<Locale?>(
  store: HiveStringStore<Locale?>(
    defaultValue: () => null,
    boxName: 'language',
    decode: (v) => v == 'null' ? null : Locale(v),
    encode: (v) => (v?.languageCode).toString(),
  ),
);

// WARN: only use outside of widget where is too hard to get ref context
StringsRu staticLocalization = AppLocaleUtils.findDeviceLocale().build();

final localizationProvider = Provider((ref) {
  final locale = ref.watch(languageProvider);
  final slangLocale = locale == null
      ? AppLocaleUtils.findDeviceLocale()
      : AppLocaleUtils.parse(locale.toLanguageTag());

  return staticLocalization = slangLocale.build();
});

final supportedLocales = AppLocale.values.map((e) => e.flutterLocale).toList();
