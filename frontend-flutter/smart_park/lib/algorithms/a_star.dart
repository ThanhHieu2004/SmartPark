import 'dart:math';

class Node {
  final String id;
  final double lat;
  final double lng;
  List<Edge> neighbors;

  Node({
    required this.id,
    required this.lat,
    required this.lng,
    this.neighbors = const [],
  });
}

class Edge {
  final Node to;
  final double cost;

  Edge({required this.to, required this.cost});
}

class AStar {
  static double heuristic(Node a, Node b) {
    double dx = a.lat - b.lat;
    double dy = a.lng - b.lng;
    return sqrt(dx * dx + dy * dy);
  }

  static List<Node> findPath(Node start, Node goal) {
    final open = <Node, double>{start: 0};
    final came = <Node, Node>{};
    final g = <Node, double>{start: 0};

    while (open.isNotEmpty) {
      Node current = open.entries.reduce((a, b) {
        return a.value < b.value ? a : b;
      }).key;

      if (current == goal) {
        return _reconstruct(came, current);
      }

      open.remove(current);

      for (var edge in current.neighbors) {
        Node next = edge.to;
        double tentative = g[current]! + edge.cost;

        if (tentative < (g[next] ?? double.infinity)) {
          came[next] = current;
          g[next] = tentative;
          open[next] = tentative + heuristic(next, goal);
        }
      }
    }

    return [];
  }

  static List<Node> _reconstruct(Map<Node, Node> came, Node current) {
    List<Node> path = [current];
    while (came.containsKey(current)) {
      current = came[current]!;
      path.add(current);
    }
    return path.reversed.toList();
  }
}
