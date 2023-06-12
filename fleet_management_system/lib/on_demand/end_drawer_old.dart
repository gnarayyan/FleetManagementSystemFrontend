import 'package:flutter/material.dart';
import '../helper/notification.dart';
// import '../helper/setting.dart' as constant;

class EndDrawerOld extends StatefulWidget {
  final int collectionRoute;
  const EndDrawerOld({super.key, required this.collectionRoute});

  @override
  State<EndDrawerOld> createState() => _EndDrawerOldState();
}

class _EndDrawerOldState extends State<EndDrawerOld> {
  var notification;

  @override
  Widget build(BuildContext context) {
    print('Collection route: ${widget.collectionRoute}');
    notification = getNotification(widget.collectionRoute);
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
                  notification[index]["related_actor"] == 'D'
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
                    notification[index]["schedule_at"],
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
