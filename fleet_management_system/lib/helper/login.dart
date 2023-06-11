import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helper/setting.dart' as constant;

// Logic to Login
Future<Map<String, dynamic>> login(String username, String password) async {
  final url = Uri.parse('${constant.apiUrl}login/');

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

    // Cache sesion/token data
    print(responseData);
    return responseData;
  } else {
    // Login failed
    print('User login failed');
    print('User login failed with status code: ${response.statusCode}');
    print('Error message: ${response.body}');
    return {};
  }
}
