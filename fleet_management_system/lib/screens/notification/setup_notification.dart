import 'package:firebase_messaging/firebase_messaging.dart';

import '../../helper/cache.dart';
import 'network_stuff.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //Handle background message
  print('Handling a background message: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  void handleNotificationClick(RemoteMessage message) {
    // Extract data from the message
    final notificationData = message.data;

    // Perform the desired action
    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      // Navigator.of(context).pushNamed(screen);
    } else {
      // Handle other types of notifications
    }
  }

  Future<void> initNotifications() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      int id = await Cache().getDeviceNotificationId();
      refreshDeviceNotificationToken(fcmToken, id);
      print('Refreshed Token: $fcmToken');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('Token: $fcmToken');
    //Register Device
    await isNotificationTokenExpired();
  }
}
