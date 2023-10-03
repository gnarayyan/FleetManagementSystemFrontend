import 'dart:convert';
import 'package:fleet_management_system/helper/setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheduleDelete extends StatelessWidget {
  final bool isDeletable;
  final String title;
  const ScheduleDelete(
      {super.key, required this.title, required this.isDeletable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MyListView(isDeletable: isDeletable),
    );
  }
}

class MyListView extends StatelessWidget {
  final bool isDeletable;
  const MyListView({super.key, required this.isDeletable});

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('${apiUrl}fleet/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteItem(int itemId) async {
    final response = await http.delete(
      Uri.parse('${apiUrl}fleet/$itemId/'),
    );
    if (response.statusCode == 200) {
      // Item deleted successfully, you can handle the response as needed
    } else {
      throw Exception('Failed to delete item');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<int, String> scheduleStatusChoices = {
      0: 'Pending',
      1: 'Accepted',
      2: 'Rejected'
    };
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Map<String, dynamic>>? items = snapshot.data;

          return ListView.builder(
            itemCount: items?.length ?? 0,
            itemBuilder: (context, index) {
              final item = items![index];

              return Dismissible(
                key: Key(item['id'].toString()), // Unique key for each item
                background: Container(
                  color:
                      Colors.red, // Background color when swiped for deletion
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  if (isDeletable) {
                    // Implement the deletion logic here
                    deleteItem(item['id']);
                    // For now, we'll just show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("${item['title']}     , Deleted"),
                      ),
                    );
                  }
                },
                child: Card(
                  child: ListTile(
                    dense: false,
                    // isThreeLine: true,
                    leading: CircleAvatar(
                      radius: 40, // Increase the image size
                      backgroundImage: NetworkImage(item['image']),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['description'],
                          style: const TextStyle(fontSize: 17),
                        ),
                        Text(
                          scheduleStatusChoices[item['status']]!,
                          style:
                              const TextStyle(fontSize: 15, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
