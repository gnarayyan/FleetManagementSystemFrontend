import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../helper/setting.dart';

Future<List<dynamic>> getCollectionPoints() async {
  String url = '${apiUrl}collection-points/';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print('Fetched Collection Points');
    // print(jsonResponse);

    return jsonResponse;
  }
  print('failed to fetch collection points');
  return [];
}
