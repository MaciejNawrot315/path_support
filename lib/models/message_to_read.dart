// ignore_for_file: constant_identifier_names

import 'dart:math';

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

String convertToRelativePosition(
    double cameraDirection, RelativePosition objectDirection) {
  double temp = convertFromRelativePositon(objectDirection);
  double outcome = temp - cameraDirection;
  print(outcome);
  if ((outcome > pi / 8 && outcome <= 3 * pi / 8) ||
      (outcome > -15 * pi / 8 && outcome <= -13 * pi / 8)) {
    return "in front of you to the left";
  }
  if ((outcome > 3 * pi / 8 && outcome <= 5 * pi / 8) ||
      (outcome > -13 * pi / 8 && outcome <= -11 * pi / 8)) {
    return "on the left of you";
  }
  if ((outcome > 5 * pi / 8 && outcome <= 7 * pi / 8) ||
      (outcome > -11 * pi / 8 && outcome <= -9 * pi / 8)) {
    return "behind you to the left";
  }
  if ((outcome > 7 * pi / 8 && outcome <= 9 * pi / 8) ||
      (outcome > -9 * pi / 8 && outcome <= -7 * pi / 8)) {
    return "behind you";
  }
  if ((outcome > 9 * pi / 8 && outcome <= 11 * pi / 8) ||
      (outcome > -7 * pi / 8 && outcome <= -5 * pi / 8)) {
    return "behind you to the right";
  }
  if ((outcome > 11 * pi / 8 && outcome <= 13 * pi / 8) ||
      (outcome > -5 * pi / 8 && outcome <= -3 * pi / 8)) {
    return "on the right of you";
  }
  if ((outcome > 13 * pi / 8 && outcome <= 15 * pi / 8) ||
      (outcome > -3 * pi / 8 && outcome <= -pi / 8)) {
    return "in front of you to the right";
  }
  return "in front of you";
}

double convertFromRelativePositon(RelativePosition relativePosition) {
  switch (relativePosition) {
    case RelativePosition.N:
      return -pi / 2;
    case RelativePosition.NW:
      return -pi / 4;
    case RelativePosition.W:
      return 0;
    case RelativePosition.SW:
      return pi / 4;
    case RelativePosition.S:
      return pi / 2;

    case RelativePosition.SE:
      return 3 * pi / 4;
    case RelativePosition.E:
      return pi;
    case RelativePosition.NE:
      return -3 * pi / 4;
  }
}

@HiveType(typeId: 4)
class MessageToRead {
  @HiveField(0)
  String message;
  @HiveField(1)
  RelativePosition position;
  MessageToRead({
    required this.message,
    required this.position,
  });

  Future<void> play(RelativePosition cameraOrientation) async {
    switch (cameraOrientation) {
      case RelativePosition.N:
        break;
      case RelativePosition.NW:
        // TODO: Handle this case.
        break;
      case RelativePosition.W:
        // TODO: Handle this case.
        break;
      case RelativePosition.SW:
        // TODO: Handle this case.
        break;
      case RelativePosition.S:
        // TODO: Handle this case.
        break;
      case RelativePosition.SE:
        // TODO: Handle this case.
        break;
      case RelativePosition.E:
        // TODO: Handle this case.
        break;
      case RelativePosition.NE:
        // TODO: Handle this case.
        break;
    }
  }
}
