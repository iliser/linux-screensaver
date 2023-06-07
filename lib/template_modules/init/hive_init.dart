import 'package:hive/hive.dart';
import 'package:template/globals.dart';

Future hiveInit() async {
  Hive.init(config.applicationSupportDirectory);
}
