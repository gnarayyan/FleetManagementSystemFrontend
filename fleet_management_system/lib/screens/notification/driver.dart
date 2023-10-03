import 'package:flutter/material.dart';

class DriverNotificationRedirect extends StatelessWidget {
  const DriverNotificationRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              //TODO:
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
                'Accept',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO:
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
                'Reject',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
