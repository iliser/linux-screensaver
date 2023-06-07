// base class for all network exceptions
import 'package:flutter/material.dart';
import 'package:template/template_modules/displayed_exception.dart';

/// the super class over all exceptions that can be thrown during network request
/// include: http errors, connection problem, json parse error
abstract class NetworkException implements DisplayedException {
  const NetworkException(this.errorMessage, this.uri);

  final Uri uri;

  /// error message from server
  @override
  final String errorMessage;

  Widget get widget;

  String get title;
  // error message that can be displayd
  String get errorDescription;

  @override
  SnackBar get errorSnackBar => SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
            Text(errorDescription),
          ],
        ),
      );
}
