// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
part 'relatively_positioned_message.g.dart';

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
class RelativelyPositionedMessage {
  @HiveField(0)
  String message;
  @HiveField(1)
  RelativePosition position;
  RelativelyPositionedMessage({
    required this.message,
    required this.position,
  });
  String convertToRelativePosition(double cameraDirection) {
    double textReleativeToCode = position.convertToRadians();
    double outcome = textReleativeToCode - cameraDirection;
    String tempString;
    if ((outcome > pi / 8 && outcome <= 3 * pi / 8) ||
        (outcome > -15 * pi / 8 && outcome <= -13 * pi / 8)) {
      tempString = "in front of you to the left";
    } else if ((outcome > 3 * pi / 8 && outcome <= 5 * pi / 8) ||
        (outcome > -13 * pi / 8 && outcome <= -11 * pi / 8)) {
      tempString = "on the left of you";
    } else if ((outcome > 5 * pi / 8 && outcome <= 7 * pi / 8) ||
        (outcome > -11 * pi / 8 && outcome <= -9 * pi / 8)) {
      tempString = "behind you to the left";
    } else if ((outcome > 7 * pi / 8 && outcome <= 9 * pi / 8) ||
        (outcome > -9 * pi / 8 && outcome <= -7 * pi / 8)) {
      tempString = "behind you";
    } else if ((outcome > 9 * pi / 8 && outcome <= 11 * pi / 8) ||
        (outcome > -7 * pi / 8 && outcome <= -5 * pi / 8)) {
      tempString = "behind you to the right";
    } else if ((outcome > 11 * pi / 8 && outcome <= 13 * pi / 8) ||
        (outcome > -5 * pi / 8 && outcome <= -3 * pi / 8)) {
      tempString = "on the right of you";
    } else if ((outcome > 13 * pi / 8 && outcome <= 15 * pi / 8) ||
        (outcome > -3 * pi / 8 && outcome <= -pi / 8)) {
      tempString = "in front of you to the right";
    } else {
      tempString = "in front of you";
    }
    return message.replaceAll("!-!-!", tempString);
  }
}

extension RelativePositionConvertion on RelativePosition {
  double convertToRadians() {
    switch (this) {
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
}
