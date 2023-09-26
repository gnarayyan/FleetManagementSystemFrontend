// ignore_for_file: avoid_print

import 'package:fleet_management_system/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../../helper/login.dart';
import 'package:fleet_management_system/screens/home/home_screen.dart';
import '../../helper/setting.dart' as constant;

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static const Color _logoColor = Color(0xFF192146);
  final username = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            FormField(
              controller: username,
              labelText: 'Username',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: firstname,
              labelText: 'Firstname',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: lastname,
              labelText: 'Lastname',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: email,
              labelText: 'Email',
            ),
            const SizedBox(height: 16.0),
            FormField(
              controller: password,
              labelText: 'Password',
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String username = this.username.text;
                String password = this.password.text;
                int userData = await login(username, password);

                if (userData == 200) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
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
                  'Signup',
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
                'Already have an account?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: _logoColor, // Customize link color
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Login page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
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
                  'LOGIN',
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

class FormField extends StatelessWidget {
  final String labelText;

  const FormField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200], // Customize input field background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
