import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize local notifications
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_round');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _localNotifications.initialize(initializationSettings);

    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Subscribe to topic
    await _firebaseMessaging.subscribeToTopic('allnotifications');
    debugPrint('notification : Subscribed to topic: allnotifications');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('notification : Got a notification whilst in the foreground!');
      print('notification : Message data: ${message.data}');

      if (message.notification != null) {
        print('notification : Message also contained a notification: ${message.notification}');
        
        // Show local notification
        await _showLocalNotification(
          title: message.notification.title ?? 'New Notification',
          body: message.notification.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle when app is terminated
    RemoteMessage initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('notification : Initial message: ${initialMessage.data}');
    }
  }

  Future<void> _showLocalNotification({
    String title,
    String body,
    String payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('notification : Handling a background message: ${message.messageId}');
} 