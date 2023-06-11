import 'package:fleet_management_system/screens/waste_form.dart';
import 'package:flutter/material.dart';
// import '../helper/location.dart';
import '../helper/setting.dart' as constant;

class MyDrawer extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MyDrawer({super.key, required this.userData});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
              widget.userData['firstname'] + ' ' + widget.userData['lastname'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              widget.userData['username'] + '@gmail.com',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                constant.backendUrl + widget.userData['avatar'],
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
                  builder: (context) => const WasteForm(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
