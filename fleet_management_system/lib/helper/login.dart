import 'dart:convert';
import 'package:fleet_management_system/helper/cache.dart';
import 'package:fleet_management_system/helper/setting.dart';
import 'package:http/http.dart' as http;
import '../helper/setting.dart' as constant;

Future<bool> tokenLogin() async {
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

  if (response.statusCode == 200) {
    // valid access token
    true;
  } else {
    //  access token is expired , so refresh the token
    print('access token is expired , so need to refresh the token');

    return refreshAccessToken();
  }
  //So refresh token is also expired need to login using username and password
  return false;
}

Future<bool> refreshAccessToken() async {
  Cache cache = Cache();

  final response = await http.post(
    Uri.parse(refreshToken),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'refresh': await cache.getRefreshToken() as String,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);

    String newAccessToken = responseData['access'];
    cache.setAccessToken(newAccessToken); //Update Token
    return true;
  }
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
    String accessToken = responseData['tokens']['access'];
    String refreshToken = responseData['tokens']['refresh'];

    // print('Data: $userId $userName $accessToken $refreshToken');

    // Cache sesion/token data
    Cache().save(userId, fullName, email, accessToken, refreshToken);
  } else {
    // Login failed
    print('User login failed');
    print('User login failed with status code: ${response.statusCode}');
    print('Error message: ${response.body}');
  }

  return response.statusCode;
}

// Logout
Future<int> logout() async {
  int? responseCode = await _logoutClient();

  if (responseCode == 200) {
    return 200;
  } else {
    // Logout failed
    print('User logout failed. Refreshing Token...');
    refreshAccessToken();

    print('re - logout ');
    responseCode = await _logoutClient();

    if (responseCode == 200) {
      print('Succesfully logout ');
      return 200;
    }
    print('Logout failed');
    return 400;
  }
}

Future<int?> _logoutClient() async {
  const url = '${constant.accountUrl}logout/';
  Cache cache = Cache();

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${cache.getAccessToken()}',
    },
  );

  if (response.statusCode == 200) {
    // Logout successful
    cache.clear();
    return response.statusCode;
  }
  return null;
}
