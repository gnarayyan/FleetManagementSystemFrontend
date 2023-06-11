// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helper/location.dart';
import 'package:image_picker/image_picker.dart';

class WasteForm extends StatefulWidget {
  const WasteForm({super.key});

  @override
  State<WasteForm> createState() => _WasteFormState();
}

class _WasteFormState extends State<WasteForm> {
  final TextEditingController volumeController = TextEditingController();
  XFile? _image;
  int nature = 1; // Default value for waste_nature field

  // Future<Map<String, double>> getWeatherData() async {
  //   Location location = Location();
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //   LocationData? locationData;

  //   // Check if location services are enabled
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       // Location services are not enabled
  //       throw Exception('Location services are disabled');
  //     }
  //   }

  //   // Check if the app has location permissions
  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       // Location permissions are not granted
  //       throw Exception('Location permissions are denied');
  //     }
  //   }

  //   // Get the current location
  //   locationData = await location.getLocation();
  //   return {
  //     'latitude': locationData.latitude!,
  //     'longitude': locationData.longitude!,
  //   };
  // }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> submitForm() async {
    const String apiUrl = 'http://127.0.0.1:8000/api/waste/demand/wastes/';

    try {
      final location = await getWeatherData();
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'latitude': location['latitude'],
          'longitude': location['longitude'],
          'waste_volume': double.parse(volumeController.text),
          'waste_nature': nature.toString(),
        },
      );

      if (response.statusCode == 201) {
        // Successful POST request
        print('Waste data submitted successfully!');
      } else {
        // Handle error case
        print(
            'Failed to submit waste data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error occurred while submitting waste data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: volumeController,
              decoration: const InputDecoration(labelText: 'Waste Volume'),
            ),
            DropdownButtonFormField<int>(
              value: nature,
              items: const [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Organic'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Plastic'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Glass'),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('Debris'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  nature = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Waste Nature'),
            ),
            ElevatedButton(
              onPressed: submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
