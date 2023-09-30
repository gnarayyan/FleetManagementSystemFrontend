// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fleet_management_system/screens/auth/login_screen.dart';
import 'package:fleet_management_system/screens/waste/popup.dart';
import 'package:flutter/material.dart';
import '../../helper/login.dart';
import 'package:fleet_management_system/screens/home/home_screen.dart';
import '../../helper/setting.dart' as constant;
import '../../utils/collection_point.dart';
import 'utils/signup_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'utils/signup_post.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const Color _logoColor = Color(0xFF192146);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final username = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String municipality = '';
  Map<String, int> municipalitiesMap = {};
  List<String> municipalityChoices = [];

  String collectionRoute = '';
  Map<String, int> collectionRoutesMap = {};
  List<String> collectionRouteChoices = [];
  File? selectedImage;

  String role = 'Household User';
  List<String> roles = ['Household User', 'Driver'];
  Map<String, String> roleValues = {'Household User': 'H', 'Driver': 'D'};

  @override
  void initState() {
    super.initState();
    _loadMunicipalitiesData();
    _loadCollectionRoutes();
  }

  void _loadCollectionRoutes() async {
    var collectionRoutesMap = await getCollectionRoutes();

    if (collectionRoutesMap.isEmpty) {
      print('No collection Routes data fetched');
      return;
    }

    setState(() {
      this.collectionRoutesMap = collectionRoutesMap;
      collectionRouteChoices = this.collectionRoutesMap.keys.toList();
      collectionRoute = collectionRouteChoices[0];
    });
  }

  void _loadMunicipalitiesData() async {
    var municipalitiesList = await getMunicipalities();

    if (municipalitiesList.isEmpty) {
      print('No municipality data fetched');
      return;
    }

    setState(() {
      for (Map m in municipalitiesList) {
        int id = m['id'];
        String name = m['name'];
        municipalitiesMap[name] = id;
      }
      municipalityChoices = municipalitiesMap.keys.toList();
      municipality = municipalityChoices[0];

      print(municipalitiesList);
      print(municipalityChoices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'fleet',
              style: TextStyle(
                  fontFamily: 'Mustica Pro',
                  fontSize: 64,
                  fontWeight: FontWeight.w600,
                  color: SignupScreen._logoColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            FormField(
              controller: username,
              labelText: 'Username',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: firstname,
              labelText: 'Firstname',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: lastname,
              labelText: 'Lastname',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: email,
              labelText: 'Email',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: password,
              labelText: 'Password',
            ),
            const SizedBox(height: 20),
            const Text('User Type'),
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
                    value: role,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: roles.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        role = newValue!;
                        // print(wasteNature);
                      });
                    },
                    underline: Container()),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Municipality'),
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
                    value: municipality,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: municipalityChoices.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        municipality = newValue!;
                        // print(wasteNature);
                      });
                    },
                    underline: Container()),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Collection Route'),
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
                    value: collectionRoute,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: collectionRouteChoices.map((String item) {
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
                        // print(wasteNature);
                      });
                    },
                    underline: Container()),
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
                                  child: const Text('Upload Photo'),
                                ),
                              );
                      }
                  }
                },
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () async {
                String username = this.username.text;
                String password = this.password.text;
                String firstname = this.firstname.text;
                String lastname = this.lastname.text;
                String email = this.email.text;

                Map<String, dynamic> userPayload = {
                  'username': username,
                  'first_name': firstname,
                  'last_name': lastname,
                  'email': email,
                  'password': password
                };
                Map<String, dynamic> profilePayload = {
                  'role': roleValues[role],
                  'municipality': municipalitiesMap[municipality],
                  'collection_route': collectionRoutesMap[collectionRoute]
                };

                print(userPayload);
                print(profilePayload);

                if (await createUserAndProfile(
                  file: selectedImage,
                  filename: basename(selectedImage!.path),
                  userPayload: userPayload,
                  profilePayload: profilePayload,
                )) {
                  showPopUpMessage(context, 'User created Successfully', true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } else {
                  showPopUpMessage(context, 'Failed to create User', false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF192146), // Customize button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Signup',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to the forgot password page
              },
              child: const Text(
                'Already have an account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: SignupScreen._logoColor, // Customize link color
                ),
              ),
            ),
            // const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Login page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Customize button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'LOGIN',
                  style:
                      TextStyle(fontSize: 16.0, color: SignupScreen._logoColor),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
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

class FormField extends StatelessWidget {
  final String labelText;

  const FormField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200], // Customize input field background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
