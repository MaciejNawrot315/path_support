import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_support/models/relatively_positioned_message.dart';

class PositionedInfoNode extends StatelessWidget {
  const PositionedInfoNode({
    Key? key,
    required this.elementWidth,
    required this.elementHeight,
    required this.positionedDescription,
    required this.radius,
    required this.screenRotationSnapshot,
    required this.compassSnapshot,
    required this.currentCompassSnapshot,
  }) : super(key: key);
  final double elementWidth;
  final double elementHeight;
  final RelativelyPositionedMessage positionedDescription;
  final double radius;
  final double screenRotationSnapshot;
  final double? compassSnapshot;
  final double? currentCompassSnapshot;
  @override
  Widget build(BuildContext context) {
    double messageRotation = positionedDescription.position.convertToRadians();
    double phoneAngleOffset = screenRotationSnapshot - compassOffset();
    double angle = messageRotation - phoneAngleOffset;
    var x = radius * sin(angle - pi);
    var y = radius * cos(angle - pi);
    return Positioned(
        left: MediaQuery.of(context).size.width / 2 - elementWidth / 2 + x,
        top: MediaQuery.of(context).size.height / 2 - elementHeight / 2 + y,
        child: Semantics(
          child: Container(
            height: elementHeight,
            width: elementWidth,
            color: Colors.yellow.withOpacity(1.0),
            child: Text(
              positionedDescription.convertToRelativePosition(
                screenRotationSnapshot - compassOffset(),
              ),
            ),
          ),
        ));
  }

  double compassOffset() {
    if (compassSnapshot == null || currentCompassSnapshot == null) {
      return 0;
    }
    return compassSnapshot! - currentCompassSnapshot!;
  }
}
