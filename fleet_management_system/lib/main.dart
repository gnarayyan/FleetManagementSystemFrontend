// import 'package:fleet_management_system/day2/upload.dart';
import 'package:fleet_management_system/helper/cache.dart';
import 'package:fleet_management_system/helper/login.dart';
import 'package:fleet_management_system/screens/auth/login_screen.dart';
import 'package:fleet_management_system/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLogined = false;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    if (await Cache().isLogin() && await tokenLogin()) {
      setState(() {
        isLogined = true;
      });
    }
  }

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
        body: SafeArea(
          child: Center(
            child: (isLogined)
                ? const HomeScreen() //lp.LocationPage()
                : const LoginScreen(), //DjangoImage(),
          ),
        ),
      ),
    );
  }
}
