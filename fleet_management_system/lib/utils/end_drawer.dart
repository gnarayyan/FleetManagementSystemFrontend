import 'package:flutter/material.dart';
import '../helper/notification.dart';
import '../helper/setting.dart' as constant;

class EndDrawer extends StatelessWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: getNotification(constant.userCollectionRoute),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print('ERROR: ${snapshot.error}');
            // Error occurred while fetching data
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Data is empty
            return const Center(
              child: Text('No notifications found'),
            );
          } else {
            // Data is available
            final List<Map<String, dynamic>> notifications = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(5),
              children: notifications.map((notification) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: CircleAvatar(
                      child: Icon(
                        notification['related_actor'] == 'D'
                            ? Icons.drive_eta
                            : Icons.dns,
                      ),
                    ),
                    title: Text(
                      notification['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification['description'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          notification['schedule_at'],
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
