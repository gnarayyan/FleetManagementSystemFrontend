import 'dart:async';

import 'package:fleet_management_system/helper/cache.dart';
import 'package:fleet_management_system/screens/home/service/location.dart';
import 'package:fleet_management_system/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/my_drawer.dart';
import '../admin/home.dart';
import 'build_markers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double latitude;
  late double longitude;
  String fullName = '';

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  List<Marker> _markers = [
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

  Set<Polyline> _polylines = {};

  bool isLoading = true;
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _getUserRole();
    if (userRole != 'A') {
      _locationTask();
      getMarkerWidgets();
      _addPolyline();
    }
  }

  void _getUserRole() async {
    String userRole = await Cache().getRole() ?? 'A';
    setState(() {
      this.userRole = userRole;
      print('User Role: ${this.userRole}');
      isLoading = false;
    });
  }

  void getMarkerWidgets() async {
    var markers = await buildMarkers();
    print('Markers Fetched....');

    // print('Fetched markers....: $markers');

    setState(() {
      _markers = markers;
    });
  }

  void _addPolyline() {
    List<LatLng> polylineCoordinates = [];

    for (Marker marker in _markers) {
      polylineCoordinates.add(marker.position);
    }

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('My Custom route'),
          points: polylineCoordinates,
          color: const Color.fromARGB(255, 243, 33, 166),
          width: 4,
        ),
      );
    });
  }

  void _locationTask() async {
    var (latitude, longitude) = await getCurrentLocation();
    String? fullName = await Cache().getFullName();

    setState(() {
      this.fullName = fullName!;
      this.latitude = latitude;
      this.longitude = longitude;

      _kGooglePlex = CameraPosition(
        target: LatLng(this.latitude, this.longitude),
        zoom: 14.4746,
      );
      isLoading = false;

      // print('Lat lang: $latitude / $longitude \n $_kGooglePlex ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${fullName.split(' ')[0]}'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(5),
                    icon: const Icon(Icons.notifications),
                    tooltip: 'Notifications',
                    onPressed: () async {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '🔴',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      endDrawer: const YourWidget(),
      body: Center(
        child: (isLoading)
            ? const CircularProgressIndicator()
            // : (userRole == 'A')
            //     ? const AdminHome()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14.4746,
                ), //_kGooglePlex,
                markers: Set.of(_markers),
                mapType: MapType.normal, // MapType.satellite,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: _polylines,
              ),
      ),
    );
  }
}
