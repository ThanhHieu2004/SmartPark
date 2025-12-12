import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../algorithms/a_star.dart';

class ParkingRouteDisplay {
  static Polyline createRoutePolyline(List<Node> path) {
    return Polyline(
      polylineId: const PolylineId("route"),
      width: 6,
      color: Colors.blue,
      points: path.map((n) => LatLng(n.lat, n.lng)).toList(),
    );
  }
}
