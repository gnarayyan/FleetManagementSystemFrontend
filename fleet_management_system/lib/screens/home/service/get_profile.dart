import 'dart:convert';

import 'package:fleet_management_system/helper/login.dart';
import 'package:fleet_management_system/helper/setting.dart';
import 'package:http/http.dart' as http;

import '../../../helper/cache.dart';

Future<String?> getInvalidData() async {
  return await Cache().getProfilePic();
}

Future<String?> getProfileUrl() async {
  Cache cache = Cache();
  String? cachedProfilePic = await cache.getProfilePic();

  if (cachedProfilePic != null) {
    return cachedProfilePic;
  }

  String? uid = await cache.getUserId();
  String? token = await cache.getAccessToken();

  String url = '${accountUrl}profile/$uid/';

  print('URL to Request: $url');

  var result = await _fetchProfile(url, token!);

  if (result != null) {
    return result;
  } else {
    print('Access Token Expired. Refreshing it...');
    bool refreshed = await refreshAccessToken();
    if (refreshed) {
      token = await cache.getAccessToken();
      print('Token Refreshed....');
      return await _fetchProfile(url, token!);
    }
  }
  print('No image Fetched, error  occur at last');
  return null;
}

Future<String?> _fetchProfile(String url, String accessToken) async {
  final response = await http.get(
    Uri.parse(url),
    // Send authorization headers to the backend.
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    // fetched successful
    final responseData = json.decode(response.body);
    String avatarUrl = responseData['avatar'];
    String finalUrl = baseUrl + avatarUrl;
    print('User Profile Url: $finalUrl');

    Cache().setProfilePic(finalUrl); // Cache the ProfilePic
    return finalUrl;
  }

  return null;
}
