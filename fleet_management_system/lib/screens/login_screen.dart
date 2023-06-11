// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../helper/login.dart';
import 'package:fleet_management_system/screens/home_screen.dart';
import '../helper/setting.dart' as constant;
// import '../helper/notification.dart';

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
                // String username = usernameController.text;
                // String password = passwordController.text;
                // Map<String, dynamic> userData = await login(username, password);
                Map<String, dynamic> userData =
                    await login('kajal', 'aggarwal@123');
                // await login('chris', '123@chrissignup');

                if (userData.isNotEmpty) {
                  constant.userCollectionRoute =
                      userData['collection_route']['id'];
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(userData: userData),
                    ),
                  );

                  // var notification =
                  //     await getNotification(constant.userCollectionRoute);
                  // print(notification);
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
