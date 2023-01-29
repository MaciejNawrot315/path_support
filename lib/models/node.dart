import 'package:hive/hive.dart';

import 'package:path_support/models/graph_link.dart';
import 'package:path_support/models/relatively_positioned_message.dart';
part 'node.g.dart';

@HiveType(typeId: 2)
class Node {
  @HiveField(0)
  String name;
  @HiveField(1)
  int tempParent;
  @HiveField(2)
  int index;
  @HiveField(3)
  List<GraphLink> links;
  @HiveField(5)
  List<RelativelyPositionedMessage> descriptions;
  @HiveField(4)
  double tempDistance;

  Node({
    required this.name,
    required this.tempParent,
    required this.index,
    required this.links,
    required this.descriptions,
    required this.tempDistance,
  });
}
