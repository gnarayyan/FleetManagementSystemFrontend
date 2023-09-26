import 'package:geolocator/geolocator.dart';

Future<dynamic> getCurrentLocation() async {
  Location location = Location();
  await location.determinePosition();

  Map locationData;
  if (location.success) {
    Position? position = location.position;
    locationData = (position == null)
        ? {}
        : {'latitude': position.latitude, 'longitude': position.longitude};
  } else {
    locationData = {};
  }
  print('MY LOCATION: $locationData');
  return locationData;
}

class Location {
  bool success = false;
  Position? position;

  // Determine the current position of the device.
  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        /* Permissions are denied, next time you could try requesting permissions again.
           According to Android guidelines
           your App should show an explanatory UI now. */
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    /* Permissions are granted and we can
    continue accessing the position of the device. */
    success = true;
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }
}
