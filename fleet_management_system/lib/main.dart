import 'package:fleet_management_system/screens/login_screen.dart';
// import 'package:fleet_management_system/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fleet Management System',
      // initialRoute: '/login',
      // routes: {
      //   '/login': (context) => LoginScreen(),
      //   // '/signup': (context) => SignupScreen(),
      //   '/home': (context) => const HomeScreen(),
      // },
      home: Scaffold(
        body: Center(
          child: LoginScreen(),
        ),
      ),
    );
  }
}
