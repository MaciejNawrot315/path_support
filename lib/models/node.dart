import 'package:hive/hive.dart';

import 'package:path_support/models/adj_node.dart';
import 'package:path_support/models/message_to_read.dart';
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
  List<AdjNode> adjNodes;
  @HiveField(5)
  List<MessageToRead> description;
  @HiveField(4)
  double tempDistance;

  Node({
    required this.name,
    required this.tempParent,
    required this.index,
    required this.adjNodes,
    required this.description,
    required this.tempDistance,
  });
}
