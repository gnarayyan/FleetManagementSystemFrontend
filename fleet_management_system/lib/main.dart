// import 'package:fleet_management_system/day2/upload.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fleet_management_system/helper/cache.dart';
import 'package:fleet_management_system/helper/login.dart';
import 'package:fleet_management_system/screens/auth/login_screen.dart';
import 'package:fleet_management_system/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/notification/setup_notification.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: 'Main Navigator');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();
  runApp(const App());

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    final screenName = message.data['screen'];
    navigatorKey.currentState?.pushNamed(screenName);
  });
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
