import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/node.dart';

part 'guide_state.dart';

class GuideCubit extends Cubit<GuideState> {
  GuideCubit() : super(const GuideInitial());
  Future<void> newBuildingChoosed(
      Building building, Node currentLocation) async {
    emit(BuildingChoosed(building: building, currentLocation: currentLocation));
    List<Node> path = fastestPathToTargetDijkstra(0, 4);
    print(path);
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
}
