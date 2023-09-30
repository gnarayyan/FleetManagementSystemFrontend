// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:fleet_management_system/helper/setting.dart';

Future<int> submitForm(
    {required File? file,
    required String filename,
    required Map<String, dynamic> payload}) async {
  ///MultiPart request
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(wasteUrl),
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

// Future<int> sendRequest(
//     {required File? file,
//     required String filename,
//     required Map<String, dynamic> payload}) async {
//   // Create Dio instance
//   final dio = Dio();

//   // Create FormData for the multipart request
//   final formData = FormData.fromMap({
//     'image': await MultipartFile.fromFile(
//       file!.path,
//       filename: filename,
//       contentType: MediaType('image', 'jpeg'),
//     ),
//     ...payload,
//   });

//   try {
//     // Send the multipart request
//     final response = await dio.post(
//       wasteUrl,
//       data: formData,
//       options: Options(
//         headers: {'Content-type': 'multipart/form-data'},
//       ),
//     );

//     // Check the response status
//     if (response.statusCode == 200) {
//       // Request was successful
//       print('Response: ${response.data}');
//       // You can parse the response here if it returns JSON
//       // var jsonData = json.decode(response.data);
//       // Handle the JSON data as needed
//     } else {
//       // Request failed
//       print('Request failed with status ${response.statusCode}');
//       print('response: ${response.data} \n ${response.statusMessage}');
//     }
//     return response.statusCode ?? -1;
//   } catch (e) {
//     // An error occurred
//     print('Error sending request: $e');
//   }
//   return 477;
// }
