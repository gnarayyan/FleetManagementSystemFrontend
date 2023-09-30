import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../helper/setting.dart';

Future<List<dynamic>> getMunicipalities() async {
  String url = '${apiUrl}info/municipality/';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);

    print('Response ..: $responseData');

    return responseData;
  }
  print('failed to fetch municipality');
  return [];
}
