import 'package:hive/hive.dart';
part 'adj_node.g.dart';

@HiveType(typeId: 3)
class AdjNode {
  @HiveField(0)
  int index;
  @HiveField(1)
  double distance;
  AdjNode({
    required this.index,
    required this.distance,
  });
}
