import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helper/setting.dart';
import 'package:fleet_management_system/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const Color _logoColor = Color(0xFF192146);
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'fleet',
              style: TextStyle(
                  fontFamily: 'Mustica Pro',
                  fontSize: 64,
                  fontWeight: FontWeight.w600,
                  color: _logoColor),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 32.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor:
                    Colors.grey[200], // Customize input field background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor:
                    Colors.grey[200], // Customize input field background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;
                Map<String, dynamic> userData = await login(username, password);
                if (userData.isNotEmpty) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(userData: userData),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF192146), // Customize button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to the forgot password page
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: _logoColor, // Customize link color
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the signup page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xffFAFAFA), // Customize button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'SIGNUP',
                  style: TextStyle(fontSize: 16.0, color: _logoColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Logic to Login
Future<Map<String, dynamic>> login(String username, String password) async {
  final url = Uri.parse(API_URL + 'login/');

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
    // final String firstname = responseData['firstname'];
    // final String lastname = responseData['lastname'];

    // final String fullname = '$firstname $lastname';
    // final String avatar = BACKEND_URL + responseData['avatar'];

    // Cache sesion/token data
    return responseData;
  } else {
    // Login failed
    print('User login failed');
    print('User login failed with status code: ${response.statusCode}');
    print('Error message: ${response.body}');
    return {};
  }
}

class UserData {
  final String firstname;
  final String lastname;
  final String avatar;
  final String username;

  const UserData(this.firstname, this.lastname, this.username, this.avatar);
}
