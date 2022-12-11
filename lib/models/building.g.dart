// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingAdapter extends TypeAdapter<Building> {
  @override
  final int typeId = 1;

  @override
  Building read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Building(
      name: fields[0] as String,
      graph: (fields[1] as List).cast<Node>(),
    );
  }

  @override
  void write(BinaryWriter writer, Building obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.graph);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
