import 'a_star.dart';

class ParkingRouteDisplay {
  /// Trả về list các điểm để bạn vẽ trên bản đồ
  static List<Map<String, double>> convertPathToPoints(List<Node> path) {
    return path
        .map((n) => {
              "x": n.lat,
              "y": n.lng,
            })
        .toList();
  }
}
