import 'package:equatable/equatable.dart';

import 'package:path_support/models/adj_node.dart';
import 'package:path_support/models/message_to_read.dart';

class Node {
  String name;
  int tempParent;
  int index;
  List<AdjNode> adjNodes;
  List<MessToRead> messToRead;
  double tempDistance;

  Node({
    required this.name,
    required this.tempParent,
    required this.index,
    required this.adjNodes,
    required this.messToRead,
    required this.tempDistance,
  });
}
