import 'package:hive/hive.dart';

import 'package:path_support/models/relatively_positioned_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graph_link.g.dart';

@JsonSerializable()
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
  factory GraphLink.fromJson(Map<String, dynamic> json) =>
      _$GraphLinkFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GraphLinkToJson(this);
}
