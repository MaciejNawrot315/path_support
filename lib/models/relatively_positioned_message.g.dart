// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatively_positioned_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageToReadAdapter extends TypeAdapter<RelativelyPositionedMessage> {
  @override
  final int typeId = 4;

  @override
  RelativelyPositionedMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelativelyPositionedMessage(
      message: fields[0] as String,
      position: fields[1] as RelativePosition,
    );
  }

  @override
  void write(BinaryWriter writer, RelativelyPositionedMessage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageToReadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RelativePositionAdapter extends TypeAdapter<RelativePosition> {
  @override
  final int typeId = 5;

  @override
  RelativePosition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RelativePosition.N;
      case 1:
        return RelativePosition.NW;
      case 2:
        return RelativePosition.W;
      case 3:
        return RelativePosition.SW;
      case 4:
        return RelativePosition.S;
      case 5:
        return RelativePosition.SE;
      case 6:
        return RelativePosition.E;
      case 7:
        return RelativePosition.NE;
      default:
        return RelativePosition.N;
    }
  }

  @override
  void write(BinaryWriter writer, RelativePosition obj) {
    switch (obj) {
      case RelativePosition.N:
        writer.writeByte(0);
        break;
      case RelativePosition.NW:
        writer.writeByte(1);
        break;
      case RelativePosition.W:
        writer.writeByte(2);
        break;
      case RelativePosition.SW:
        writer.writeByte(3);
        break;
      case RelativePosition.S:
        writer.writeByte(4);
        break;
      case RelativePosition.SE:
        writer.writeByte(5);
        break;
      case RelativePosition.E:
        writer.writeByte(6);
        break;
      case RelativePosition.NE:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelativePositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
