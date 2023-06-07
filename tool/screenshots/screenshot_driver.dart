import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

const langTag = 'ru-RU';

Future<void> main() {
  return integrationDriver(
    onScreenshot: (
      screenshotName,
      screenshotBytes, [
      args,
    ]) async {
      final image = File(
        './android/fastlane/metadata/android/$langTag/images/phoneScreenshots/$screenshotName.png',
      );
      image.writeAsBytesSync(screenshotBytes);
      // Return false if the screenshot is invalid.
      return true;
    },
  );
}
