import 'package:hive/hive.dart';

import 'package:path_support/models/node.dart';

part 'building.g.dart';

@HiveType(typeId: 1)
class Building {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Node> graph;
  @HiveField(2)
  String fullName;
  Building({
    required this.name,
    required this.graph,
    required this.fullName,
  });
}
