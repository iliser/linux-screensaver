import 'package:dio/dio.dart';

extension CancelTokenExtension on CancelToken {
  // create token that cancel when `this` or token canceled
  CancelToken withToken(CancelToken token) {
    final token = CancelToken();

    Future.any([
      token.whenCancel,
      whenCancel,
    ]).then((value) => value.error).then(token.cancel);
    return token;
  }

  // create token that cancel when `this` canceled or future completes
  CancelToken withFuture(Future<dynamic> future) {
    final token = CancelToken();
    Future.any([
      future,
      whenCancel.then((value) => value.error),
    ]).then(token.cancel);
    return token;
  }
}
