import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/message_to_read.dart';
import 'package:path_support/models/node.dart';

part 'guide_state.dart';

class GuideCubit extends Cubit<GuideState> {
  GuideCubit() : super(const GuideInitial());
  Future<void> newBuildingChoosed(
      Building building, Node currentLocation) async {
    emit(BuildingChoosed(building: building, currentLocation: currentLocation));
  }

  Future<void> findDestination(String name, RelativePosition qrAngle) async {
    Building building = state.building!;
    Node currentLocation = state.currentLocation!;
    int target = building.graph.indexWhere((element) => element.name == name);
    List<Node> path =
        fastestPathToTargetDijkstra(currentLocation.index, target);
    emit(TargetChoosed(
      building: building,
      currentLocation: currentLocation,
      path: path,
      target: target,
      currentStep: 0,
      currentRotation: qrAngle,
    ));
  }

  Future<void> nextStep(int newNodeIndex) async {
    int currentStep = state.currentStep!;
    int nextStep = currentStep + 1;
    if (newNodeIndex == state.path[nextStep].index) {
      Node currentLocation = state.path[nextStep];
      emit((state as TargetChoosed).copyWith(
        currentStep: nextStep,
        currentLocation: currentLocation,
      ));
    }
  }

  void targetReached() {
    emit(TargetReached(
      currentLocation: state.currentLocation!,
      building: state.building!,
    ));
  }

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
      for (int i = 0; i < currentNode.adjNodes.length; i++) {
        int adjacentIndex = currentNode.adjNodes[i].index;

        double totalDistance =
            currentNode.tempDistance + currentNode.adjNodes[i].distance;
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

  void descriptionMode() {
    emit(GuideDescriptionMode(
      building: state.building!,
    ));
  }

  void navigationMode() {
    emit(GuideNavigationMode(
      building: state.building!,
      currentLocation: state.currentLocation!,
    ));
  }
}
