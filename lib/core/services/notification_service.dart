import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Message received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    await _saveToken();
  }

  Future<void> _saveToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null) {
        debugPrint('FCM token obtained (save to backend not yet implemented)');
      }
    } catch (e) {
      debugPrint('Error obtaining FCM token: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? '',
      platformDetails,
    );
  }
}
