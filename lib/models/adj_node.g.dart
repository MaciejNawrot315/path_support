// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adj_node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdjNodeAdapter extends TypeAdapter<AdjNode> {
  @override
  final int typeId = 3;

  @override
  AdjNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdjNode(
      index: fields[0] as int,
      distance: fields[1] as double,
      pathDescriptions: (fields[2] as List).cast<MessageToRead>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdjNode obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
      ..write(obj.pathDescriptions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdjNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
