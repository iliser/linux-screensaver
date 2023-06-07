import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:template/globals.dart';

Future onesignalInit() async {
  if (kDebugMode) {
    await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  }

  await OneSignal.shared.setAppId(config.onesignalAppId);

  // TOOD change behavior to data notification, right now just show all notification
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
    (e) => e.complete(e.notification),
  );

  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
  // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: false);

  if (config.onesignalDefaultExternalUserId != null) {
    await OneSignal.shared
        .setExternalUserId(config.onesignalDefaultExternalUserId!);
  }
}
