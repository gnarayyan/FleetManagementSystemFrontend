// ignore_for_file: avoid_print

import 'package:fleet_management_system/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import '../../helper/login.dart';
import 'package:fleet_management_system/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const Color _logoColor = Color(0xFF192146);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  String loginMsg = '';
  Color msgColor = Colors.red;
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'fleet',
                style: TextStyle(
                    fontFamily: 'Mustica Pro',
                    fontSize: 64,
                    fontWeight: FontWeight.w600,
                    color: LoginScreen._logoColor),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors
                      .grey[200], // Customize input field background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  suffix: IconButton(
                    onPressed: () {
                      //add Icon button at end of TextField
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword == true
                          ? Icons.remove_red_eye
                          : Icons.visibility_off,
                      size: 20,
                    ),
                  ),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors
                      .grey[200], // Customize input field background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: showPassword,
              ),
              const SizedBox(height: 24.0),
              Text(
                loginMsg,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  int responseCode = await login(username, password);

                  String newMsg = (responseCode == 200)
                      ? 'Login Successfully'
                      : (responseCode == 400)
                          ? 'Invalid Username or Password'
                          : (responseCode == 503)
                              ? 'Server Unavilable'
                              : 'Invalid Operation';

                  setState(() {
                    loginMsg = newMsg;
                    if (responseCode == 200) {
                      msgColor = Colors.green;
                    }
                  });

                  if (responseCode == 200) {
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
                    color: LoginScreen._logoColor, // Customize link color
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the signup page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(),
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
                    'SIGNUP',
                    style: TextStyle(
                        fontSize: 16.0, color: LoginScreen._logoColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
