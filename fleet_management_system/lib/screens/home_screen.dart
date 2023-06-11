import 'dart:async';

import 'package:fleet_management_system/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/my_drawer.dart';

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
                    onPressed: () {
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
                        '9',
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

        // actions: <Widget>[
        //   Builder(
        //     builder: (BuildContext context) {
        //       return Padding(
        //         padding: const EdgeInsets.only(right: 8.0),
        //         child: IconButton(
        //           icon: const Icon(Icons.notifications),
        //           tooltip: 'Notifications',
        //           onPressed: () {
        //             Scaffold.of(context).openEndDrawer();
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      drawer: MyDrawer(
        userData: widget.userData,
      ),
      endDrawer: YourWidget(
          collectionRoute: widget.userData['collection_route']['id']),
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
