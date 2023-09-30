import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/setting.dart';

Future<Map<String, int>> getCollectionRoutes() async {
  String url = '${apiUrl}collection-routes/';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    Map<String, int> idToNameMap = {};

    print('Response ..: $responseData');

    for (var item in responseData) {
      int id = item['id'];
      String name = item['name'];
      idToNameMap[name] = id;
    }
    return idToNameMap;
  }
  print('failed to fetch collection routes');
  return {};
}

Future<bool> createCollectionPoint(
    String latitude, String longitude, String name, int collRoute) async {
  var jsonDataToSend = {
    'latitude': latitude,
    'longitude': longitude,
    'name': name,
    'collection_route': collRoute
  };
  final response = await http.post(Uri.parse('${apiUrl}collection-points/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(jsonDataToSend));
  print('Data send at request page: $jsonDataToSend');
  print('Response code on adding collection point: $response.statusCode');
  return response.statusCode == 201;
}
