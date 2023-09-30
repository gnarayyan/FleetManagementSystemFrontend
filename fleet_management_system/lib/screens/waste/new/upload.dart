import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../helper/setting.dart';
import '../../home/service/location.dart';
import '../components/dropdown.dart';
import '../popup.dart';
import './services.dart';
import 'dart:io';
import 'package:path/path.dart';

class OnDemand extends StatefulWidget {
  final String title;
  const OnDemand({required this.title, super.key});

  @override
  State<OnDemand> createState() => _OnDemandState();
}

class _OnDemandState extends State<OnDemand> {
  File? selectedImage;
  String latitude = '';
  String longitude = '';
  var wasteVolume = TextEditingController();
  String wasteNature = wasteNatureChoices.keys.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text('Waste Volume in m3'),
            const SizedBox(height: 5),
            TextField(
              controller: wasteVolume,
              decoration: InputDecoration(
                labelText: 'Estimated waste volume',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Waste Nature'),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the value as needed
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 1.0, // Border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                    isExpanded: true,
                    elevation: 12,
                    hint: const Text('Select an option'),
                    // Initial Value
                    value: wasteNature,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items:
                        (wasteNatureChoices.keys.toList()).map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        wasteNature = newValue!;
                        // print(wasteNature);
                      });
                    },
                    underline: Container()),
              ),
            ),

            const SizedBox(height: 16.0),
            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              child: FutureBuilder(
                future: _getImage(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('Please wait');
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return selectedImage != null
                            ? Image.file(selectedImage!)
                            : Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFAFAFA),
                                    foregroundColor: const Color(0xFF192146),
                                  ),
                                  onPressed: getImage,
                                  child: const Text('Upload Waste Photo'),
                                ),
                              );
                      }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //---
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var (latitude, longitude) = await getCurrentLocation();

                setState(() {
                  this.latitude = latitude.toString();
                  this.longitude = longitude.toString();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
                foregroundColor: const Color(0xFF192146),
                padding: const EdgeInsets.all(15.0), // This is what you need!
              ),
              child: const Text(
                'Grant Location Access',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 5.0),
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> payload = {
                      'latitude': latitude.toString(),
                      'longitude': longitude.toString(),
                      'waste_volume': double.parse(wasteVolume.text),
                      'waste_nature': wasteNatureChoices[wasteNature],
                      'waste_for': wasteForChoices[widget.title]
                    };
                    int responseCode = await submitForm(
                      file: selectedImage,
                      filename: basename(selectedImage!.path),
                      payload: payload,
                    );
                    print('Submitted...... $responseCode');
                    bool isSuccessful = responseCode == 201;
                    String msg =
                        (isSuccessful) ? 'Successfully Added' : 'Failed to Add';
                    showPopUpMessage(context, msg, isSuccessful);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF192146),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //get image from camera
  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image!.path);
    });
    //return image;
  }

  //resize the image
  Future<void> _getImage(BuildContext context) async {
    if (selectedImage != null) {
      var imageFile = selectedImage;
      /*var image = imageLib.decodeImage(imageFile.readAsBytesSync());
      fileName = basename(imageFile.path);
      image = imageLib.copyResize(image,
          width: (MediaQuery.of(context).size.width * 0.8).toInt(),
          height: (MediaQuery.of(context).size.height * 0.7).toInt());
      _image = image;*/
    }
  }
}
