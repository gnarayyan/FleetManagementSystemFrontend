import 'dart:async';

import 'package:fleet_management_system/helper/drawer.dart';
// import 'package:fleet_management_system/flutter_flow/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.42796133580664, -122.085749655962),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(37.42796133580664, -122.095749655962),
      infoWindow: InfoWindow(
        title: 'My Current Location',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.userData["firstname"]}'),
      ),
      drawer: MyDrawer(
        userData: widget.userData,
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set.of(_markers),
        mapType: MapType.normal, // MapType.satellite,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
