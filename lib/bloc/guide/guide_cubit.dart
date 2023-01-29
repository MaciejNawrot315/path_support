import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/node.dart';

part 'guide_state.dart';

class GuideCubit extends Cubit<GuideState> {
  GuideCubit() : super(const GuideInitial());
  Future<void> newBuildingChoosed(Building building, Node currentLocation,
      double currentRotation, double? compassSnapshot) async {
    emit(GuideModeSelection(
      building: building,
      currentLocation: currentLocation,
      currentRotation: currentRotation,
      compassSnapshot: compassSnapshot,
    ));
  }

  Future<bool> navigateTo(int target) async {
    Building building = state.building!;
    Node currentLocation = state.currentLocation!;
    List<Node> path =
        fastestPathToTargetDijkstra(currentLocation.index, target);
    emit(GuideNavigationMode(
        building: building,
        currentLocation: currentLocation,
        path: path,
        target: target,
        currentStep: 0,
        currentRotation: state.currentRotation!,
        compassSnapshot: state.compassSnapshot));
    return true;
  }

  int findNodeIndex(String name) {
    Building building = state.building!;
    int target = building.graph.indexWhere(
        (element) => element.name.toLowerCase() == name.toLowerCase());
    return target;
  }

  Future<void> newCodeScannedInDescriptionMode(
      int nodeIndex, double qrCodeRotation, double? compassSnapshot) async {
    emit(GuideDescriptionMode(
      building: state.building!,
      currentLocation: state.building!.graph[nodeIndex],
      currentRotation: qrCodeRotation,
      compassSnapshot: compassSnapshot,
    ));
  }

  Future<void> nextStep(int newNodeIndex, double? compassSnapshot) async {
    int currentStep = state.currentStep!;
    int nextStep = currentStep + 1;
    if (newNodeIndex == state.path[nextStep].index) {
      Node currentLocation = state.path[nextStep];
      emit((state as GuideNavigationMode).copyWith(
          currentStep: nextStep,
          currentLocation: currentLocation,
          compassSnapshot: compassSnapshot));
    }
  }

  void targetReached(
      {required Node currentLocation,
      required double currentRotation,
      double? compassSnapshot}) {
    emit(GuideTargetReached(
      currentLocation: currentLocation,
      building: state.building!,
      currentRotation: currentRotation,
      compassSnapshot: compassSnapshot,
    ));
  }

//TODO wybranie budynku w ktorym się jest na początku aplikacji
  List<Node> fastestPathToTargetDijkstra(int startingNode, int target) {
    List<Node> graph = state.building!.graph;
    for (Node node in graph) {
      node.tempDistance = double.infinity;
    }
    graph[startingNode].tempDistance = 0;
    List<Node> shortestPath = [];
    List<Node> unvisitedNodes = graph.toList();
    List<Node> visitedNodes = [];
    Node currentNode = unvisitedNodes[startingNode];

    currentNode.tempDistance = 0;
    while (currentNode.index != target) {
      for (int i = 0; i < currentNode.links.length; i++) {
        int adjacentIndex = currentNode.links[i].index;

        double totalDistance =
            currentNode.tempDistance + currentNode.links[i].distance;
        if (totalDistance < graph[adjacentIndex].tempDistance) {
          graph[adjacentIndex].tempDistance = totalDistance;
          graph[adjacentIndex].tempParent = currentNode.index;
        }
      }

      visitedNodes.add(currentNode);
      unvisitedNodes.remove(currentNode);
      unvisitedNodes.sort((a, b) =>
          graph[a.index].tempDistance.compareTo(graph[b.index].tempDistance));
      currentNode = graph[unvisitedNodes[0].index];
    }
    while (currentNode != graph[startingNode]) {
      shortestPath.add(currentNode);
      currentNode = graph[currentNode.tempParent];
    }
    shortestPath.add(graph[startingNode]);
    shortestPath = shortestPath.reversed.toList();
    return shortestPath;
  }

  void descriptionMode(
      {Building? building,
      Node? currentLocation,
      double? currentRotation,
      double? compassSnapshot}) {
    emit(GuideDescriptionMode(
      building: building ?? state.building!,
      currentLocation: currentLocation ?? state.currentLocation!,
      currentRotation: currentRotation ?? state.currentRotation!,
      compassSnapshot: compassSnapshot ?? state.compassSnapshot,
    ));
  }

  void navigationMode() {
    emit(GuideDestinationSelection(
      building: state.building!,
      currentLocation: state.currentLocation!,
      currentRotation: state.currentRotation!,
      compassSnapshot: state.compassSnapshot,
    ));
  }
}
