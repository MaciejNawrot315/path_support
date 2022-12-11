part of 'guide_cubit.dart';

abstract class GuideState extends Equatable {
  final Building? building;
  final Node? currentLocation;
  const GuideState({
    this.building,
    this.currentLocation,
  });

  @override
  List<Object> get props => [];
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
