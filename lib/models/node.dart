import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:path_support/models/graph_link.dart';
import 'package:path_support/models/relatively_positioned_message.dart';
part 'node.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class Node {
  @HiveField(0)
  String name;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @HiveField(1)
  int tempParent;
  @HiveField(2)
  int index;
  @HiveField(3)
  List<GraphLink> links;
  @HiveField(5)
  List<RelativelyPositionedMessage> descriptions;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @HiveField(4)
  double tempDistance;

  Node({
    required this.name,
    required this.index,
    required this.links,
    required this.descriptions,
  })  : tempDistance = double.infinity,
        tempParent = -1;
  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

  Map<String, dynamic> toJson() => _$NodeToJson(this);
}
