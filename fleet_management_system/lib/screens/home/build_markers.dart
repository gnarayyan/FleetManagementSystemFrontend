import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'fetch_markers.dart';

Future<List<Marker>> buildMarkers() async {
  List<Marker> markers = [];

  List<dynamic> markerData = await getCollectionPoints();

  if (markerData.isEmpty) {
    print('No markers fetched');
  }

  for (var data in markerData) {
    final id = data['id'].toString();
    final latitude = double.parse(data['latitude']);
    final longitude = double.parse(data['longitude']);
    final name = data['name'];

    final marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      markerId: MarkerId(id),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name,
      ),
    );

    markers.add(marker);
  }

  return markers;
}

// class BuildMarkerList extends StatefulWidget {
//   const BuildMarkerList({super.key});

//   @override
//   State<BuildMarkerList> createState() => _BuildMarkerListState();
// }

// class _BuildMarkerListState extends State<BuildMarkerList> {
//   List<Map<String, dynamic>> markerData = [];

//   @override
//   void initState() {
//     super.initState();
//     // Build the set of Markers from the input data
//     getMarkers();
//     _buildMarkers();
//   }

//   void getMarkers() async {
//     setState(() {
//       this.markerData = markerData;
//     });
//   }

//   void _buildMarkers() {}

  // @override
  // Widget build(BuildContext context) {
  //   return GoogleMap(
  //     initialCameraPosition: const CameraPosition(
  //       target: LatLng(0, 0), // Adjust the initial map position as needed
  //       zoom: 10, // Initial zoom level
  //     ),
  //     markers: markers,
  //     onMapCreated: (GoogleMapController controller) {
  //       // You can perform additional actions when the map is created
  //     },
  //   );
  // }

