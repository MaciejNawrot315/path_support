part of 'guide_cubit.dart';

abstract class GuideState {
  final Building? building;
  final Node? currentLocation;
  final List<Node> path;
  final int? target;
  final int? currentStep;
  final double? currentRotation;
  final double? compassSnapshot;
  const GuideState({
    this.building,
    this.currentLocation,
    this.path = const [],
    this.target,
    this.currentStep,
    this.currentRotation,
    this.compassSnapshot,
  });
}

class GuideInitial extends GuideState {
  const GuideInitial();
}

class GuideModeSelection extends GuideState {
  const GuideModeSelection({
    required Building building,
    required Node currentLocation,
    required double currentRotation,
    required double? compassSnapshot,
  }) : super(
          building: building,
          currentLocation: currentLocation,
          currentRotation: currentRotation,
          compassSnapshot: compassSnapshot,
        );
}

class GuideDestinationSelection extends GuideState {
  const GuideDestinationSelection({
    required Building building,
    required Node currentLocation,
    required double currentRotation,
    required double? compassSnapshot,
  }) : super(
          building: building,
          currentLocation: currentLocation,
          currentRotation: currentRotation,
          compassSnapshot: compassSnapshot,
        );
}

class GuideDescriptionMode extends GuideState {
  const GuideDescriptionMode({
    required Building building,
    required double currentRotation,
    required Node currentLocation,
    required double? compassSnapshot,
  }) : super(
          building: building,
          currentLocation: currentLocation,
          currentRotation: currentRotation,
          compassSnapshot: compassSnapshot,
        );
  GuideDescriptionMode copyWith({
    Building? building,
    Node? currentLocation,
    double? currentRotation,
    double? compassSnapshot,
  }) {
    return GuideDescriptionMode(
      building: building ?? this.building!,
      currentLocation: currentLocation ?? this.currentLocation!,
      currentRotation: currentRotation ?? this.currentRotation!,
      compassSnapshot: compassSnapshot ?? this.compassSnapshot!,
    );
  }
}

class GuideNavigationMode extends GuideState {
  const GuideNavigationMode({
    required Building building,
    required Node currentLocation,
    required List<Node> path,
    required int target,
    required int currentStep,
    required double currentRotation,
    required double? compassSnapshot,
  }) : super(
          building: building,
          currentLocation: currentLocation,
          path: path,
          target: target,
          currentStep: currentStep,
          currentRotation: currentRotation,
          compassSnapshot: compassSnapshot,
        );
  GuideNavigationMode copyWith({
    Building? building,
    Node? currentLocation,
    List<Node>? path,
    int? target,
    int? currentStep,
    double? currentRotation,
    double? compassSnapshot,
  }) {
    return GuideNavigationMode(
      building: building ?? this.building!,
      currentLocation: currentLocation ?? this.currentLocation!,
      path: path ?? this.path,
      target: target ?? this.target!,
      currentStep: currentStep ?? this.currentStep!,
      currentRotation: currentRotation ?? this.currentRotation!,
      compassSnapshot: compassSnapshot ?? this.compassSnapshot!,
    );
  }
}

class GuideTargetReached extends GuideState {
  const GuideTargetReached({
    required Building building,
    required double currentRotation,
    required Node currentLocation,
    required double? compassSnapshot,
  }) : super(
            currentLocation: currentLocation,
            building: building,
            currentRotation: currentRotation,
            compassSnapshot: compassSnapshot);
}
