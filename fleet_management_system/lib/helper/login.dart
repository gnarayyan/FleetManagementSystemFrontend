import 'dart:convert';
import 'package:fleet_management_system/helper/cache.dart';
import 'package:fleet_management_system/helper/setting.dart';
import 'package:http/http.dart' as http;
import '../helper/setting.dart' as constant;

Future<bool> tokenLogin() async {
  if (!await _tokenLoginHelper()) {
    print('access token is expired , so need to refresh the token');

    if (!await refreshAccessToken()) {
      print(
          'So refresh token is also expired need to login using username and password');
      return false;
    }
  }
  return true;
}

Future<bool> _tokenLoginHelper() async {
  Cache cache = Cache();

  String? accessToken = await cache.getAccessToken();
  final url = Uri.parse('${constant.accountUrl}login/');

  final response = await http.get(
    url,
    // Send authorization headers to the backend.
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  return response.statusCode == 200;
}

Future<bool> refreshAccessToken() async {
  Cache cache = Cache();
  String? cachedRefreshToken = await cache.getRefreshToken();

  final response = await http.post(
    Uri.parse(refreshToken),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'refresh': cachedRefreshToken as String,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);

    String newAccessToken = responseData['access'];
    cache.setAccessToken(newAccessToken); //Update Token
    print('Access token Refreshed');
    return true;
  }
  print('Fail to refresh Access token');
  return false;
}

// username Password to Login
Future<int> login(String username, String password) async {
  final url = Uri.parse('${constant.accountUrl}login/');

  final response = await http.post(
    url,
    body: {
      'username': username,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    // Login successful
    final Map<String, dynamic> responseData = json.decode(response.body);

    // print(responseData);

    int userId = responseData['id'];
    String fullName = responseData['fullname'];
    String email = responseData['email'];
    String role = responseData['role'];
    String accessToken = responseData['tokens']['access'];
    String refreshToken = responseData['tokens']['refresh'];

    // print('Data: $userId $userName $accessToken $refreshToken');

    // Cache sesion/token data
    Cache().save(userId, fullName, email, role, accessToken, refreshToken);
  } else {
    // Login failed
    print('User login failed');
    print('User login failed with status code: ${response.statusCode}');
    print('Error message: ${response.body}');
  }

  return response.statusCode;
}

// Logout
Future<bool> logout() async {
  if (!await Cache().isLogin()) {
    return true;
  }

  if (!await _logoutClient()) {
    // Logout failed
    print('User logout failed. Refreshing Token...');
    refreshAccessToken();
    print('Token Refreshed');
    print('Again trying to logout ');

    if (!await _logoutClient()) {
      print('Logout failed');
      return false;
    }
  }
  print('Succesfully logout ');
  await Cache().clear();
  return true;
}

Future<bool> _logoutClient() async {
  const url = '${constant.accountUrl}logout/';
  Cache cache = Cache();

  String? accessToken = await cache.getAccessToken();

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  return response.statusCode == 200;
}
