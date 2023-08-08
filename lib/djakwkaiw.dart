class Dijkstra {
  static Map singleSourceShortestPaths(graph, s, end) {
    var predecessors = {};

    var costs = {};
    costs[s] = 0;

    var open = PriorityQueue();
    open.add(s, 0);

    var closest,
        u,
        costOfSToU,
        adjacentNodes,
        costOfE,
        costOfSToUPlusCostOfE,
        costOfSToV,
        firstVisit;
    while (!open.empty()) {
      closest = open.pop();
      u = closest?["value"];
      costOfSToU = closest["cost"];

      adjacentNodes = graph[u] ?? {};

      (adjacentNodes as Map).forEach((v, value) {
        if (adjacentNodes?[v] != null) {
          costOfE = adjacentNodes[v];

          costOfSToUPlusCostOfE = costOfSToU + costOfE;

          costOfSToV = costs[v];
          firstVisit = costs[v] == null;
          if (firstVisit || costOfSToV > costOfSToUPlusCostOfE) {
            costs[v] = costOfSToUPlusCostOfE;
            open.add(v, costOfSToUPlusCostOfE);
            predecessors[v] = u;
          }
        }
      });
    }

    if (end != null && costs[end] == null) {
      print('Could not find a path');
    }

    return predecessors;
  }

  static List extractShortestPathFromPredecessorList(predecessors, end) {
    var nodes = [];
    var u = end;
    while (u != null) {
      nodes.add(u);
      u = predecessors[u];
    }
    if (nodes.length == 1) return [];
    return nodes.reversed.toList();
  }

  static List findPathFromGraph(Map graph, dynamic start, dynamic end) {
    var predecessors = singleSourceShortestPaths(graph, start, end);

    return extractShortestPathFromPredecessorList(predecessors, end);
  }
}

class PriorityQueue {
  List queue = [];
  PriorityQueue();

  add(value, cost) {
    Map<String, dynamic> item = {"value": value, "cost": cost};
    queue.add(item);
    queue.sort((a, b) {
      return (a["cost"] * 10000).truncate() - (b["cost"] * 10000).truncate();
    });
  }

  pop() {
    return queue.removeAt(0);
  }

  bool empty() {
    return queue.isEmpty;
  }
}
