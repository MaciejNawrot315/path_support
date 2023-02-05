import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_support/models/graph_link.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/relatively_positioned_message.dart';
import 'package:path_support/models/node.dart';

class HiveSetup {
  static Future<void> hiveInitialization() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(BuildingAdapter())
      ..registerAdapter(NodeAdapter())
      ..registerAdapter(RelativelyPositionedMessageAdapter())
      ..registerAdapter(RelativePositionAdapter())
      ..registerAdapter(GraphLinkAdapter());
    await Hive.openBox("buildings");
  }
}
