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
      tempParent: fields[1] as int,
      index: fields[2] as int,
      links: (fields[3] as List).cast<GraphLink>(),
      descriptions: (fields[5] as List).cast<RelativelyPositionedMessage>(),
      tempDistance: fields[4] as double,
    );
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
