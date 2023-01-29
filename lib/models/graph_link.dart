import 'package:hive/hive.dart';

import 'package:path_support/models/relatively_positioned_message.dart';

part 'graph_link.g.dart';

@HiveType(typeId: 3)
class GraphLink {
  @HiveField(0)
  int index;
  @HiveField(1)
  double distance;
  @HiveField(2)
  List<RelativelyPositionedMessage> pathDescriptions;
  GraphLink({
    required this.index,
    required this.distance,
    required this.pathDescriptions,
  });
}
