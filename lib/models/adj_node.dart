import 'package:hive/hive.dart';

import 'package:path_support/models/message_to_read.dart';

part 'adj_node.g.dart';

@HiveType(typeId: 3)
class AdjNode {
  @HiveField(0)
  int index;
  @HiveField(1)
  double distance;
  @HiveField(2)
  List<MessageToRead> pathDescriptions;
  AdjNode({
    required this.index,
    required this.distance,
    required this.pathDescriptions,
  });
}
