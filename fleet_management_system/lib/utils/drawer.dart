import 'package:fleet_management_system/helper/cache.dart';
import 'package:fleet_management_system/helper/login.dart';
import 'package:fleet_management_system/screens/forms/collection_point.dart';
import 'package:fleet_management_system/screens/waste/on_demand.dart';
import 'package:fleet_management_system/utils/collection_point.dart';
import 'package:flutter/material.dart';
import '../on_demand/ondemand_waste_screen.dart';
import '../screens/home/service/get_profile.dart';
import '../screens/home/service/location.dart';
// import '../on_demand/waste_form.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String fullName = '';
  String email = '';
  String profileUrl = '';
  // final _formKey = GlobalKey<FormState>();
  double latitude = 0.0;
  double longitude = 0.0;
  Map<String, int> collectionRoutes = {};
  String? selectedOption;
  String responseResult = '';

  var collectionPointName = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    Cache cache = Cache();
    String? fullName = await cache.getFullName();
    String? email = await cache.getEmail();
    Map<String, int> collectionRoutes = await getCollectionRoutes();
    // Selected dropdown option

    String profileUrl = await getProfileUrl() ??
        'https://cdn.pixabay.com/photo/2014/04/02/10/25/man-303792_640.png'; // await use garexi future hatxa

    print('Profile URL: $profileUrl');
    setState(() {
      this.fullName = fullName ?? '';
      this.email = email ?? '';
      this.profileUrl = profileUrl;
      this.collectionRoutes = collectionRoutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            // <-- SEE HERE
            decoration: const BoxDecoration(color: Color(0xff764abc)),
            accountName: Text(
              fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                profileUrl,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.recycling,
            ),
            title: const Text('On Demand Waste'),
            onTap: () {
              // Navigator.pop(context);
              // getWeatherData();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OnDemandWaste(), //WasteForm(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.add_location_alt_sharp,
            ),
            title: const Text('Add Collection Point'),
            onTap: () {
              Navigator.pop(context);

              // TextEditingController labelController = TextEditingController();
              if (collectionRoutes.isNotEmpty) {
                showDialog<void>(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return SingleChildScrollView(
                            child: AlertDialog(
                              content: Card(
                                // margin: const EdgeInsets.all(16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        'Collection Route',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        hint: const Text('Select an option'),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOption = newValue!;
                                          });
                                        },
                                        items: collectionRoutes.keys
                                            .toList()
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: collectionRoutes[value]
                                                  .toString(), // Assuming 'id' is a string or can be converted to one
                                              child: Text(
                                                  value), // Assuming 'name' is a string or can be converted to one
                                            );
                                          },
                                        ).toList(),
                                        value: selectedOption,
                                      ),
                                      const SizedBox(height: 16.0),
                                      TextField(
                                        controller: collectionPointName,
                                        decoration: InputDecoration(
                                          labelText: 'Collection Point Name',
                                          filled: true,
                                          fillColor: Colors.grey[
                                              200], // Customize input field background color
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                        onPressed: () async {
                                          var (latitude, longitude) =
                                              await getCurrentLocation();

                                          setState(() {
                                            this.latitude = latitude;
                                            this.longitude = longitude;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(
                                              15.0), // This is what you need!
                                        ),
                                        child: const Text(
                                          'Grant Location Access',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      Text('Latitude: $latitude'),
                                      Text('Longitude: $longitude'),
                                      // const SizedBox(height: 10.0),
                                      // Text(
                                      //   responseResult,
                                      //   style: const TextStyle(fontSize: 30.0),
                                      // ),
                                      const SizedBox(height: 40.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              bool success =
                                                  await createCollectionPoint(
                                                      latitude,
                                                      longitude,
                                                      collectionPointName.text,
                                                      int.parse(selectedOption
                                                          as String));

                                              setState(() {
                                                responseResult = (success)
                                                    ? '✅\nAdded'
                                                    : '❌\nFailed';
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                  0xFF192146), // This is what you need!
                                            ),
                                            child: const Text('Save'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Implement the Cancel logic here
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .red, // This is what you need!
                                            ),
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30.0),
                                      Text(
                                        responseResult,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 30.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    });
              } else {
                print('No Collection Routes');
              }
              // Navigator.pop(context);
              // // getWeatherData();
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const AddCollectionPoint(),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () async {
              int resCode = await logout();
              if (resCode == 200) {
                Navigator.of(context).pop();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const LoginScreen(),
                //   ),
              } else {
                print('fail to Logout....');
              }
            },
          ),
        ],
      ),
    );
  }
}
