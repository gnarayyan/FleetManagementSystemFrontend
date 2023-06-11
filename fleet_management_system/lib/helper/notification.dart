// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helper/setting.dart' as constant;

// Logic to Fetch Notifications

Future<List<Map<String, dynamic>>> getNotification(int collectionRoute) async {
  Uri url = Uri.parse('${constant.scheduleUrl}$collectionRoute');

  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    Future<List<Map<String, dynamic>>> jsonResponse =
        jsonDecode(response.body); // as List<Map<String, dynamic>>;
    // print('Collection: ${constant.userCollectionRoute}');
    // var itemCount = jsonResponse.length;

    // print('Number of schedules about http: $itemCount.');
    print('Response: $jsonResponse');
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    print('Error message: ${response.body}');
    return [];
  }
}
