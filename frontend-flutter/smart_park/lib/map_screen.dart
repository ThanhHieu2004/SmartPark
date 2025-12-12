import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/navigation_service.dart';
import '../algorithms/a_star.dart';
import '../widgets/parking_route_display.dart';
import '../models/parking_slot.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _center = LatLng(
    10.762622,
    106.660172,
  ); // Ho Chi Minh City
  late GoogleMapController mapController;

  final NavigationService _navService = NavigationService();

  // data to test
  final List<ParkingSlot> parkingSlots = [
    ParkingSlot(id: "P1", lat: 10.763, lng: 106.661, isEmpty: true),
    ParkingSlot(id: "P2", lat: 10.764, lng: 106.662, isEmpty: false),
    ParkingSlot(id: "P3", lat: 10.765, lng: 106.660, isEmpty: true),
  ];

  // example graph
  final List<Node> parkingGraphNodes = [];

  Set<Polyline> _polylines = {};

  LatLng _currentUserPosition = _center;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _guideToNearestSlot() {
    final pathNodes = _navService.navigateToNearestSlot(
      userPos: _currentUserPosition,
      slots: parkingSlots,
      graph: parkingGraphNodes,
    );

    final polyline = ParkingRouteDisplay.createRoutePolyline(pathNodes);

    setState(() {
      _polylines = {polyline};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: _polylines,
        onCameraMove: (position) {
          _currentUserPosition = position.target;
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _guideToNearestSlot, child: const Icon(Icons.navigation),),
    );
  }
}
