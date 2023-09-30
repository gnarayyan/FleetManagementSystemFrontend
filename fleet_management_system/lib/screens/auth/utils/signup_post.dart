// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:fleet_management_system/helper/setting.dart';

Future<bool> createUserAndProfile(
    {required File? file,
    required String filename,
    required Map<String, dynamic> userPayload,
    required Map<String, dynamic> profilePayload}) async {
  int userId = -1;

  //Create Account
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${accountUrl}register/user/'),
  );
  Map<String, String> headers = {'Content-type': 'multipart/form-data'};

  request.headers.addAll(headers);

  // Add payload data as fields
  userPayload.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  try {
    // Send the request
    var response = await request.send();

    // Check the response status
    if (response.statusCode == 201) {
      // Request was successful
      String responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');
      // You can parse the response here if it returns JSON
      var jsonData = json.decode(responseBody);
      // Handle the JSON data as needed
      userId = jsonData['id'];
      print('User Created');
    } else {
      // Request failed
      print('Failed to Create User');
      print('Request failed with status ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // An error occurred
    print('Error sending request: $e');
    return false;
  }

  // Create user Profile
  request = http.MultipartRequest(
    'POST',
    Uri.parse('${accountUrl}register/profile/'),
  );

  request.files.add(
    http.MultipartFile(
      'avatar',
      file!.readAsBytes().asStream(),
      file.lengthSync(),
      filename: filename,
      contentType: MediaType('image', 'jpeg'),
    ),
  );
  request.headers.addAll(headers);

  // Add payload data as fields
  profilePayload['user'] = userId;
  profilePayload.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  try {
    // Send the request
    var response = await request.send();

    // Check the response status
    if (response.statusCode == 201) {
      // Request was successful
      String responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');
      // You can parse the response here if it returns JSON
      // var jsonData = json.decode(responseBody);
      // Handle the JSON data as needed
      print('Profile Created');
    } else {
      // Request failed
      print('Failed to Create Profile');
      print('Request failed with status ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // An error occurred
    print('Error sending request: $e');
    return false;
  }

  return true;
}
