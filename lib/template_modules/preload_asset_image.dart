import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<ImageProvider> preloadImage(
  ImageProvider image, {
  double? dpi,
  // decode image to put it in cache without this image has been decoded on build
  bool decode = true,
}) async {
  final completer = Completer<void>();
  final imageStream = image.resolve(
    ImageConfiguration(devicePixelRatio: dpi),
  );

  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (ImageInfo imageInfo, bool synchronousCall) {
      if (decode) {
        imageInfo.image
            .toByteData(format: ui.ImageByteFormat.rawUnmodified)
            .then(
          (ByteData? byteData) async {
            imageStream.removeListener(listener);
            if (!completer.isCompleted) completer.complete();
          },
        );
      } else {
        imageStream.removeListener(listener);
        if (!completer.isCompleted) completer.complete();
      }
    },
    onError: (exception, stackTrace) {
      imageStream.removeListener(listener);
      if (!completer.isCompleted) {
        completer.completeError(exception, stackTrace);
      }
    },
  );

  imageStream.addListener(listener);

  await completer.future;

  return image;
}

//  preload asset image without context
Future<ImageProvider> preloadAssetImage(String assetPath, {double? dpi}) async {
  return preloadImage(AssetImage(assetPath), dpi: dpi);
}
