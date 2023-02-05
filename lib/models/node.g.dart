// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NodeAdapter extends TypeAdapter<Node> {
  @override
  final int typeId = 2;

  @override
  Node read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Node(
      name: fields[0] as String,
      index: fields[2] as int,
      links: (fields[3] as List).cast<GraphLink>(),
      descriptions: (fields[5] as List).cast<RelativelyPositionedMessage>(),
    )
      ..tempParent = fields[1] as int
      ..tempDistance = fields[4] as double;
  }

  @override
  void write(BinaryWriter writer, Node obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tempParent)
      ..writeByte(2)
      ..write(obj.index)
      ..writeByte(3)
      ..write(obj.links)
      ..writeByte(5)
      ..write(obj.descriptions)
      ..writeByte(4)
      ..write(obj.tempDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Node _$NodeFromJson(Map<String, dynamic> json) => Node(
      name: json['name'] as String,
      index: json['index'] as int,
      links: (json['links'] as List<dynamic>)
          .map((e) => GraphLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      descriptions: (json['descriptions'] as List<dynamic>)
          .map((e) =>
              RelativelyPositionedMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'links': instance.links.map((e) => e.toJson()).toList(),
      'descriptions': instance.descriptions.map((e) => e.toJson()).toList(),
    };
