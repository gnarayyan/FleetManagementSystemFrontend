import 'package:flutter/material.dart';

void showPopUpMessage(BuildContext context, String message, bool isSuccess) {
  Color colortext = (isSuccess) ? Colors.green : Colors.green;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Done'),
        content: Text(
          message,
          style: TextStyle(fontSize: 20.0, color: colortext),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
