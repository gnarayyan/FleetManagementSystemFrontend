// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:fleet_management_system/helper/setting.dart';

Future<int> submitForm({required File? file, required String filename}) async {
  ///MultiPart request
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(testUrl),
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
  request.fields.addAll({'name': 'test image'});
  print('request: $request');
  var res = await request.send();
  print('This is response:$res');
  return res.statusCode;
}
