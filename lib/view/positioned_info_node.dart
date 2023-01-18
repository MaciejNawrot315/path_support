import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_support/models/message_to_read.dart';

class PositionedInfoNode extends StatelessWidget {
  const PositionedInfoNode({
    Key? key,
    required this.nodeWidth,
    required this.nodeHeight,
    required this.messageToRead,
    required this.radius,
    required this.currentRotation,
    required this.compassSnapshot,
    required this.currentCompassSnapshot,
  }) : super(key: key);
  final double nodeWidth;
  final double nodeHeight;
  final MessageToRead messageToRead;
  final double radius;
  final double currentRotation;
  final double? compassSnapshot;
  final double? currentCompassSnapshot;
  @override
  Widget build(BuildContext context) {
    double messageRotation = messageToRead.position.convertToRadians();
    double temp = currentRotation - compassOffset();
    double angle2 = messageRotation - temp;
    var x = radius * sin(angle2 - pi);
    var y = radius * cos(angle2 - pi);
    return Positioned(
        left: MediaQuery.of(context).size.width / 2 - nodeWidth / 2 + x,
        top: MediaQuery.of(context).size.height / 2 - nodeHeight / 2 + y,
        child: Semantics(
          child: Container(
            height: nodeHeight,
            width: nodeWidth,
            color: Colors.yellow.withOpacity(1.0),
            child: Text(
              messageToRead.convertToRelativePosition(
                currentRotation - compassOffset(),
              ),
            ),
          ),
        ));
  }

  double compassOffset() {
    if (compassSnapshot == null) {
      return 0;
    }
    if (currentCompassSnapshot == null) {
      return 0;
    }
    return compassSnapshot! - currentCompassSnapshot!;
  }
}
