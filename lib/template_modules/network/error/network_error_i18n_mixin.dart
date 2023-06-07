import 'package:flutter/material.dart';
import 'package:template/i18n/strings.g.dart';

import 'network_exceptions.dart';

final _widgetBuilder = {
  "icon.no_connection": (_) => const Icon(Icons.wifi_off, size: 64),
};

mixin NetworkErrorI18NMixin on NetworkException {
  I18NErrorDescription get description;

  @override
  Widget get widget => description.code.isEmpty
      ? const SizedBox.shrink()
      : _widgetBuilder[description.code]?.call(this) ?? Text(description.code);

  @override
  String get title => description.title;
  // error message that can be displayd
  @override
  String get errorDescription => description.description;
}
