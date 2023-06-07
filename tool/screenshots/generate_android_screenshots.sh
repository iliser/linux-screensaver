#!/usr/bin/env bash
set -e

if [ "$(flutter emulators | grep flutter_emulator -c)" -lt 1 ]; then
    flutter emulators --create;
fi

flutter emulators --launch flutter_emulator
adb wait-for-device
adb shell "cmd uimode night yes"
flutter drive --target=tool/screenshots/capture_screenshots.dart  --driver=tool/screenshots/screenshot_driver.dart
adb emu kill