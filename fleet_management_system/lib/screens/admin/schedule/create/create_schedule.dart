import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../../../../utils/collection_point.dart';
import '../../../waste/popup.dart';
import 'add_to_db.dart';

class CreateSchedule extends StatefulWidget {
  const CreateSchedule({super.key});

  @override
  State<CreateSchedule> createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  static Map<String, int> scheduleStatusChoices = {
    'Pending': 0,
    'Accepted': 1,
    'Rejected': 2
  };
  late Map<String, int> collectionRouteChoices;
  late List<dynamic> driverChoices;

  File? selectedImage;
  var title = TextEditingController();
  var description = TextEditingController();

  String scheduleStatus = scheduleStatusChoices.keys.first;
  late int driver;
  String collectionRoute = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    var collectionRouteChoices = await getCollectionRoutes();
    var driverChoices = await getUsers(role: 'D');
    setState(() {
      this.collectionRouteChoices = collectionRouteChoices;
      collectionRoute = this.collectionRouteChoices.keys.toList()[0];
      this.driverChoices = driverChoices;
      driver = this.driverChoices[0]['user'];
      // print('Drivers: ${this.driverChoices}');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Schedule')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: 'Title of Notification',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: description,
              decoration: InputDecoration(
                labelText: 'Describe the Notification',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                                  child:
                                      const Text('Upload Notification Photo'),
                                ),
                              );
                      }
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            const Divider(height: 2, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('Collection Status'),
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
                    value: scheduleStatus,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: (scheduleStatusChoices.keys.toList())
                        .map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        scheduleStatus = newValue!;
                      });
                    },
                    underline: Container()),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Collection Route'),
            (isLoading)
                ? const CircularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the value as needed
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
                          value: collectionRoute,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: (collectionRouteChoices.keys.toList())
                              .map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              collectionRoute = newValue!;
                            });
                          },
                          underline: Container()),
                    ),
                  ),
            const Text('Driver'),
            (isLoading)
                ? const CircularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the value as needed
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<int>(
                          isExpanded: true,
                          elevation: 40,
                          hint: const Text('Select an option'),
                          // Initial Value
                          value: driver,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Array list of items
                          items: [
                            for (var i = 0; i < driverChoices.length; i++)
                              DropdownMenuItem(
                                  alignment: AlignmentDirectional.topStart,
                                  value: driverChoices[i]['user'],
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: NetworkImage(
                                                driverChoices[i]['avatar']),
                                            // width: 60,
                                            height: 120,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            driverChoices[i]['full_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Color.fromARGB(
                                                    255, 51, 42, 111),
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                          ],
                          onChanged: (int? newValue) {
                            setState(() {
                              driver = newValue!;
                            });
                            print('User Id: $driver');
                          },
                          underline: Container()),
                    ),
                  ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> payload = {
                  'title': title.text,
                  'description': description.text,
                  'status': scheduleStatusChoices[scheduleStatus],
                  'collection_route': collectionRouteChoices[collectionRoute],
                  'driver': driver
                };

                print('Data to send: $payload');
                int responseCode = await submitFleetSchedule(
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
