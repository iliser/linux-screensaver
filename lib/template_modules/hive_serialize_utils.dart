// ignore_for_file: implementation_imports

import 'dart:isolate';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:hive/src/binary/binary_reader_impl.dart';
import 'package:hive/src/binary/binary_writer_impl.dart';

// use hive adapters to serialize into binary format
Uint8List hiveToBinary<T extends Object>(T object) {
  return (BinaryWriterImpl(Hive)..write(object)).toBytes();
}

// use hive adapters to deserialize from binary format
T hiveFromBinary<T>(Uint8List buffer) =>
    BinaryReaderImpl(buffer, Hive).read() as T;

extension HiveBufferToTransferable on Uint8List {
  TransferableTypedData toTranferableData() =>
      TransferableTypedData.fromList([this]);
}
