part of 'compass_bloc.dart';

abstract class CompassBlocEvent {
  const CompassBlocEvent(
    this.headingForCameraMode,
  );
  final double headingForCameraMode;
}
