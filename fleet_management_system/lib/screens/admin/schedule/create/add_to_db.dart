import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:fleet_management_system/helper/setting.dart';

Future<int> submitFleetSchedule(
    {required File? file,
    required String filename,
    required Map<String, dynamic> payload}) async {
  ///MultiPart request
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${apiUrl}fleet/'),
  );
  Map<String, String> headers = {'Content-type': 'multipart/form-data'};
  request.files.add(
    http.MultipartFile(
      'image',
      file!.readAsBytes().asStream(),
      file.lengthSync(),
      filename: filename,
      contentType: MediaType('image', 'jpeg'),
    ),
  );
  request.headers.addAll(headers);

  // Add payload data as fields
  payload.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  print('Payload: $payload');

  try {
    // Send the request
    var response = await request.send();

    // Check the response status
    if (response.statusCode == 200) {
      // Request was successful
      String responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');
      // You can parse the response here if it returns JSON
      var jsonData = json.decode(responseBody);
      // Handle the JSON data as needed
      print('Json data:  $jsonData');
    } else {
      // Request failed
      print('Request failed with status ${response.statusCode}');
    }
    return response.statusCode;
  } catch (e) {
    // An error occurred
    print('Error sending request: $e');
  }
  return 477;
}
