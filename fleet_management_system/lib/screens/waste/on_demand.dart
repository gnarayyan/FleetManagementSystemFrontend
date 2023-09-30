// ignore_for_file: avoid_print

import 'package:fleet_management_system/screens/auth/signup.dart';
import 'package:fleet_management_system/screens/waste/components/dropdown.dart';
import 'package:flutter/material.dart';

import '../home/service/location.dart';

class OnDemandWaste extends StatefulWidget {
  const OnDemandWaste({super.key});
  static const Color _logoColor = Color(0xFF192146);

  @override
  State<OnDemandWaste> createState() => _OnDemandWasteState();
}

class _OnDemandWasteState extends State<OnDemandWaste> {
  final wasteVolume = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;

  // String wasteNature = '';

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   wasteNature = (wasteNatureChoices.keys.toList()[0]);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Fill form for On-Demand Waste',
                  style: TextStyle(
                    fontFamily: 'Mustica Pro',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: OnDemandWaste._logoColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: wasteVolume,
                  decoration: InputDecoration(
                    labelText: 'Estimated Waste Volume cubic meter',
                    filled: true,
                    fillColor: Colors
                        .grey[200], // Customize input field background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const MyDropDown(),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () async {
                      var (latitude, longitude) = await getCurrentLocation();

                      setState(() {
                        this.latitude = latitude;
                        this.longitude = longitude;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFAFAFA),
                      foregroundColor: OnDemandWaste._logoColor,
                      padding:
                          const EdgeInsets.all(15.0), // This is what you need!
                    ),
                    child: const Text(
                      'Grant Location Access',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),

                // Submit
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {},
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
                          'Submit',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Customize button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
