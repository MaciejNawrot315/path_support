// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
part 'message_to_read.g.dart';

@HiveType(typeId: 5)
enum RelativePosition {
  @HiveField(0)
  N,
  @HiveField(1)
  NW,
  @HiveField(2)
  W,
  @HiveField(3)
  SW,
  @HiveField(4)
  S,
  @HiveField(5)
  SE,
  @HiveField(6)
  E,
  @HiveField(7)
  NE
}

@HiveType(typeId: 4)
class MessToRead {
  @HiveField(0)
  String message;
  @HiveField(1)
  RelativePosition position;
  MessToRead({
    required this.message,
    required this.position,
  });

  String convertToString(RelativePosition cameraOrientation) {
    //TODO
    return '';
  }
}
