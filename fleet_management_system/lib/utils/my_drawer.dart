import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YourWidget extends StatefulWidget {
  const YourWidget({Key? key}) : super(key: key);

  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  List<Map<String, dynamic>> notification = [];

  @override
  void initState() {
    super.initState();
    getNotificationData();
  }

  Future<void> getNotificationData() async {
    Uri url =
        Uri.parse('http://127.0.0.1:8000/api/schedule/?collection_route=${1}');

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        notification = List<Map<String, dynamic>>.from(jsonResponse);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Error message: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: notification.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: CircleAvatar(
                child: Icon(
                  notification[index]['related_actor'] == 'D'
                      ? Icons.drive_eta
                      : Icons.dns,
                ),
              ),
              title: Text(
                notification[index]['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification[index]['description'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification[index]['schedule_at'].replaceAll('Â', ''),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
