part of 'guide_cubit.dart';

abstract class GuideState {
  final Building? building;
  final Node? currentLocation;
  final List<Node> path;
  final int? target;
  final int? currentStep;
  final RelativePosition? currentRotation;
  const GuideState({
    this.building,
    this.currentLocation,
    this.path = const [],
    this.target,
    this.currentStep,
    this.currentRotation,
  });
}

class GuideInitial extends GuideState {
  const GuideInitial();
}

class BuildingChoosed extends GuideState {
  const BuildingChoosed({
    required Building building,
    required Node currentLocation,
  }) : super(building: building, currentLocation: currentLocation);
}

class GuideNavigationMode extends GuideState {
  const GuideNavigationMode({
    required Building building,
    required Node currentLocation,
  }) : super(
          building: building,
          currentLocation: currentLocation,
        );
}

class GuideDescriptionMode extends GuideState {
  const GuideDescriptionMode({
    required Building building,
  }) : super(
          building: building,
        );
}

class TargetChoosed extends GuideState {
  const TargetChoosed({
    required Building building,
    required Node currentLocation,
    required List<Node> path,
    required int target,
    required int currentStep,
    required RelativePosition currentRotation,
  }) : super(
          building: building,
          currentLocation: currentLocation,
          path: path,
          target: target,
          currentStep: currentStep,
          currentRotation: currentRotation,
        );
  TargetChoosed copyWith({
    Building? building,
    Node? currentLocation,
    List<Node>? path,
    int? target,
    int? currentStep,
    RelativePosition? currentRotation,
  }) {
    return TargetChoosed(
      building: building ?? this.building!,
      currentLocation: currentLocation ?? this.currentLocation!,
      path: path ?? this.path,
      target: target ?? this.target!,
      currentStep: currentStep ?? this.currentStep!,
      currentRotation: currentRotation ?? this.currentRotation!,
    );
  }
}

class TargetReached extends GuideState {
  const TargetReached(
      {required Building building, required Node currentLocation})
      : super(currentLocation: currentLocation, building: building);
}
