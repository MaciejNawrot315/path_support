import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_support/models/adj_node.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/message_to_read.dart';
import 'package:path_support/models/node.dart';

class HiveSetup {
  static Future<void> hiveInitialization() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(BuildingAdapter())
      ..registerAdapter(NodeAdapter())
      ..registerAdapter(MessToReadAdapter())
      ..registerAdapter(RelativePositionAdapter())
      ..registerAdapter(AdjNodeAdapter());
    await Hive.openBox("buildings");
  }
}
