import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../algorithms/a_star.dart';
import '../models/parking_slot.dart';

class NavigationService {
  ParkingSlot findNearestSlot(LatLng pos, List<ParkingSlot> slots) {
    final empty = slots.where((s) => s.isEmpty).toList();

    empty.sort((a, b) {
      double da = _distance(pos.latitude, pos.longitude, a.lat, a.lng);
      double db = _distance(pos.latitude, pos.longitude, b.lat, b.lng);
      return da.compareTo(db);
    });

    return empty.first;
  }

  Node findNearestNode(LatLng pos, List<Node> nodes) {
    nodes.sort((a, b) {
      double da = _distance(pos.latitude, pos.longitude, a.lat, a.lng);
      double db = _distance(pos.latitude, pos.longitude, b.lat, b.lng);
      return da.compareTo(db);
    });
    return nodes.first;
  }

  double _distance(double la1, double lo1, double la2, double lo2) {
    double dx = la1 - la2;
    double dy = lo1 - lo2;
    return sqrt(dx * dx + dy * dy);
  }

  List<Node> navigateToNearestSlot({
    required LatLng userPos,
    required List<ParkingSlot> slots,
    required List<Node> graph,
  }) {
    final target = findNearestSlot(userPos, slots);

    final startNode = findNearestNode(userPos, graph);
    final goalNode = findNearestNode(
      LatLng(target.lat, target.lng),
      graph,
    );

    return AStar.findPath(startNode, goalNode);
  }
}
