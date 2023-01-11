import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassBloc extends Bloc<CompassEvent, double?> {
  CompassBloc() : super(0) {
    on<CompassEvent>((event, emit) {
      emit(convertAngleToDirection(event.heading));
    });
  }
  double? convertAngleToDirection(double? angle) {
    if (angle == null) {
      return null;
    }
    double recalculatedAngle;
    if (angle < 90) {
      recalculatedAngle = 360 - (90 - angle);
    } else {
      recalculatedAngle = angle - 90;
    }
    return pi + (-recalculatedAngle * pi / 180);
  }
}
