import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:upgrader/upgrader.dart';

import 'package:template/globals.dart';

Future<void> checkAndroidUpdate() async {
  log('Check update', name: 'UpdateChecker');
  final updateInfo = await InAppUpdate.checkForUpdate();

  log('Update info : $updateInfo', name: 'UpdateChecker');

  if (updateInfo.flexibleUpdateAllowed) {
    log('Background download', name: 'UpdateChecker');
    await InAppUpdate.startFlexibleUpdate();

    gScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(staticLocalization.newVersionSnackBarTitle),
        action: SnackBarAction(
          label: staticLocalization.newVersionSnackBarInstall,
          onPressed: InAppUpdate.performImmediateUpdate,
        ),
      ),
    );
  }
}

Future<void> checkIosUpdate() async {
  await Upgrader().initialize();

  Upgrader().checkVersion(context: gScaffoldMessengerKey.currentContext!);
}

void checkUpdate() async {
  try {
    if (Platform.isAndroid) await checkAndroidUpdate();
    if (Platform.isIOS) await checkIosUpdate();
  } catch (err) {
    log('Update error: $err', name: 'UpdateChecker');
    // ignore: unawaited_futures
    Sentry.captureException(err);
  }
}
