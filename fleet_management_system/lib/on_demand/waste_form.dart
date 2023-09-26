import '../helper/location.dart';
import '../helper/setting.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class WasteForm extends StatefulWidget {
  const WasteForm({super.key});

  @override
  State<WasteForm> createState() => _WasteFormState();
}

class _WasteFormState extends State<WasteForm> {
  final TextEditingController volumeController = TextEditingController();
  int nature = 1;
  PlatformFile? _image;

  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first;
      });
    }
  }

  Future<void> submitForm() async {
    const apiUrl = '${baseUrl}waste/demand/wastes/';
    const Map<String, int> wasteNatureMap = {
      'Organic': 1,
      'Plastic': 2,
      'Glass': 3,
      'Debris': 4,
    };

    final location = await getCurrentLocation();
    if (location == null) {
      print('Failed to retrieve location.');
      return;
    }

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add form fields
    request.fields['latitude'] = location['latitude'].toString();
    request.fields['longitude'] = location['longitude'].toString();
    request.fields['waste_volume'] = volumeController.text;
    request.fields['waste_nature'] =
        wasteNatureMap.keys.firstWhere((key) => wasteNatureMap[key] == nature);

    // Add new field
    request.fields['waste_for'] = 0.toString();

    // Add image file if selected
    if (_image != null && _image!.bytes != null) {
      Image.memory(
        _image!.bytes!,
        height: 150,
        width: 150,
      );
    }

    // if (_image != null) {
    //   request.files.add(http.MultipartFile.fromBytes(
    //     'image',
    //     _image!.bytes!,
    //     filename: _image!.name,
    //   ));
    // }
    print('FINAL DATA: ${request.fields}');
    // Send the request
    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        // Successful POST request
        print('Waste data submitted successfully!');
      } else {
        // Handle error case
        print(
            'Failed to submit waste data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions
      print('Failed to submit waste data. Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Forms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          children: [
            TextField(
              controller: volumeController,
              decoration: InputDecoration(labelText: '-Waste Volume'),
            ),
            DropdownButtonFormField<int>(
              value: nature,
              onChanged: (value) {
                setState(() {
                  nature = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Organic'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Plastic'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Glass'),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Text('Debris'),
                ),
              ],
              decoration: InputDecoration(labelText: 'Waste Nature'),
            ),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            if (_image != null)
              Image.memory(
                _image!.bytes!,
                height: 150,
                width: 150,
              ),
            ElevatedButton(
              onPressed: submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
