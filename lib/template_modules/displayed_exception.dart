import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../globals.dart';

/// This exception provide text to user and display it in snackbar
class DisplayedException implements Exception {
  /// construct exception with given _text.
  /// in subclass if text does't provided so text geter must be overrided
  const DisplayedException(this.errorMessage);

  final String errorMessage;

  @override
  String toString() {
    return '$runtimeType("$errorMessage")';
  }

  /// build snackbar that has been displayed on error
  SnackBar get errorSnackBar => SnackBar(content: Text(errorMessage));

  static bool doNotDisplay(Hint? hint) {
    return hint?.get(_doNotDisplayKey) == _doNotDisplaySymbol;
  }

  static const _doNotDisplayKey = "do_not_display";
  static const _doNotDisplaySymbol = Symbol("do_not_display_symbol");
  // hint for sentry to prevent display this hint and report it
  static final doNotDisplayHint = Hint.withMap({
    _doNotDisplayKey: _doNotDisplaySymbol,
  });
}

void displayError(DisplayedException error) {
  gScaffoldMessengerKey.currentState!.showSnackBar(error.errorSnackBar);
}
