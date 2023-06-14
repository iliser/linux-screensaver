// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:rxdart/rxdart.dart';

// StreamTransformer<Uint8List, List<int>> unit8Transformer =
//     StreamTransformer.fromHandlers(handleData: (data, sink) => sink.add(data));

// class SseTransformer extends StreamTransformerBase<String, SseEvent> {
//   const SseTransformer();
//   @override
//   Stream<SseEvent> bind(Stream<String> stream) {
//     return Stream.eventTransformed(stream, (sink) => SseEventSink(sink));
//   }
// }

// class SseEventSink extends EventSink<String> {
//   SseEventSink(this._eventSink);

//   final EventSink<SseEvent> _eventSink;

//   String? _id;
//   String _event = "";
//   String _data = "";
//   int? _retry;

//   @override
//   void add(String event) {
//     if (event.startsWith("id:")) {
//       _id = event.substring(3);
//       return;
//     }
//     if (event.startsWith("event:")) {
//       _event = event.substring(6);
//       return;
//     }
//     if (event.startsWith("data:")) {
//       _data = event.substring(5);
//       return;
//     }
//     if (event.startsWith("retry:")) {
//       _retry = int.tryParse(event.substring(6));
//       return;
//     }
//     if (event.isEmpty) {
//       _eventSink
//           .add(SseEvent(id: _id, event: _event, data: _data, retry: _retry));

//       _id = null;
//       _event = "";
//       _data = "";
//       _retry = null;
//     }
//   }

//   @override
//   void addError(Object error, [StackTrace? stackTrace]) {
//     _eventSink.addError(error, stackTrace);
//   }

//   @override
//   void close() {
//     _eventSink.close();
//   }
// }

// @immutable
// class SseEvent {
//   const SseEvent({
//     this.id,
//     required this.event,
//     required this.data,
//     this.retry,
//   });

//   final String? id;
//   final String event;
//   final String data;
//   final int? retry;
// }

// // TODO add error processing
// extension SseResponse on Response<ResponseBody> {
//   Stream<SseEvent> get sseStream {
//     if (data == null) return const Stream.empty();

//     return data!.stream
//         .transform(unit8Transformer)
//         .transform(const Utf8Decoder())
//         .transform(const LineSplitter())
//         .transform(const SseTransformer());
//   }
// }

// extension DioSseExtension on Dio {
//   Stream<SseEvent> getSse(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     required CancelToken cancelToken,
//   }) {
//     DateTime lastReconnect = DateTime.now();
//     Duration reconnectTimeout() {
//       if (DateTime.now().difference(lastReconnect).inSeconds < 5) {
//         return Duration(milliseconds: 2000 + Random().nextInt(6000));
//       }
//       return const Duration(seconds: 0);
//     }

//     final controller = StreamController<SseEvent>();
//     cancelToken.whenCancel.then((value) => controller.close());

//     late void Function() reconnect;
//     reconnect = () async {
//       final ans = await get<ResponseBody>(
//         path,
//         queryParameters: queryParameters,
//         options:
//             (options ?? Options()).copyWith(responseType: ResponseType.stream),
//         cancelToken: cancelToken,
//       );

//       ans.sseStream.doOnError((_, __) async {
//         await Future.delayed(reconnectTimeout());
//         lastReconnect = DateTime.now();
//         reconnect();
//       });

//       await controller.addStream(
//         ans.sseStream
//             .doOnError((_, __) => reconnect())
//             .materialize()
//             .where((event) => !event.isOnError)
//             .dematerialize(),
//       );
//     };
//     reconnect();

//     return controller.stream;
//   }
// }
