import 'package:path_support/models/node.dart';

class Guide {
  List<Node> fastestPathToTargetDijkstra(
      int startingNode, List<Node> graph, int target) {
    List<Node> shortestPath = [];
    List<Node> unvisitedNodes = graph.toList();
    List<Node> visitedNodes = [];
    Node currentNode = unvisitedNodes[startingNode];
    for (Node node in unvisitedNodes) {
      node.tempDistance = double.infinity;
    }
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
