// Starting point for create integration tests
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
// ignore: unused_import
import 'package:template/main.dart' as app;

const langTag = 'ru-RU';
var currentScreenshotId = 0;

Future<void> screenshot(IntegrationTestWidgetsFlutterBinding binding) async {
  await binding.takeScreenshot('${++currentScreenshotId}_$langTag');
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets(
    'take screenshot',
    (WidgetTester tester) async {
      app.showDebugBanner = false;
      app.main();
      await binding.convertFlutterSurfaceToImage();
      // NOT DELETE without this delay test stale on "Test starting..."
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await screenshot(binding);

      unawaited(app.gAppRouter.navigateNamed('/http_error/403'));
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await screenshot(binding);

      // await Future.delayed(const Duration(seconds: 5));
      expect(1, 1);
    },
  );
}
