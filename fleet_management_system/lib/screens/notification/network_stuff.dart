import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../helper/cache.dart';
import '../../helper/setting.dart';

Future<String?> getFCMToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken;
}

// Future<bool> isDeviceRegisterForNotification() async {
//   String? userId = await Cache().getUserId();
//   String url = '${apiUrl}notification/user/$userId/';

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 404) {
//     return false;
//   } else if (response.statusCode == 200) {
//     return true;
//   }
//   print('Unknown Error');
//   return false;
// }

Future<bool> isNotificationTokenExpired() async {
  String? userId = await Cache().getUserId();

  if (userId == null) {
    print('Invalid userId....');
    return false;
  }
  String url = '${apiUrl}notification/user/$userId/';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 404) {
    print('Device does not exists');
    print('Registering device......');

    bool isRegistered = await registerDeviceForNotification();
    (isRegistered)
        ? print('Device is Registered Successfully')
        : print('Failed to Register Device');
  }

  if (response.statusCode == 200) {
    print('Device exist in server');
    // Check whether token is expired
    final responseData = json.decode(response.body);
    String? token = await getFCMToken();
    int deviceId = responseData['id'];

    Cache().setDeviceNotificationId(deviceId);

    if (token == null) {
      print('Token fteched is null');
    } else {
      String serverToken = responseData['token'];
      if (token != serverToken) {
        // update token
        print('Device token expired');
        print('Refreshing token');
        refreshDeviceNotificationToken(token, deviceId);
      }
    }

    return true;
  }

  print('Notification is expired');
  return false;
}

Future<bool> registerDeviceForNotification() async {
  String? userId = await Cache().getUserId();
  if (userId == null) {
    print('Inavalid user Id');
    return false;
  }

  var jsonDataToSend = {
    'user': int.parse(userId),
    'token': getFCMToken(),
    'platform': getPlatformId()
  };

  final response = await http.post(
    Uri.parse('${apiUrl}notification/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(jsonDataToSend),
  );
  // print('Data send at request page: $jsonDataToSend');
  // print('Response code on adding collection point: $response.statusCode');
  if (response.statusCode == 201) {
    final responseData = json.decode(response.body);
    int deviceNotificationId = responseData['id'];

    Cache().setDeviceNotificationId(deviceNotificationId);
    return responseData;
  }
  return response.statusCode == 201;
}

Future<bool> refreshDeviceNotificationToken(
    String newToken, int deviceId) async {
  // String? userId = await Cache().getUserId();

  // if (userId == null) {
  //   print('Inavalid user Id');
  //   return false;
  // }

  //get user
  // int deviceNotificationId = await Cache().getDeviceNotificationId();

  var jsonDataToSend = {'token': newToken};

  final response = await http.patch(
    Uri.parse('${apiUrl}notification/$deviceId/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(jsonDataToSend),
  );
  // print('Data send at request page: $jsonDataToSend');
  print('Response code on adding collection point: $response.statusCode');
  return response.statusCode == 200;
}

int getPlatformId() {
  int platformName = kIsWeb
      ? 2
      : Platform.isAndroid
          ? 0
          : Platform.isIOS
              ? 1
              : Platform.isLinux
                  ? 5
                  : Platform.isMacOS
                      ? 4
                      : Platform.isWindows
                          ? 3
                          : -1;
  return platformName;
}
