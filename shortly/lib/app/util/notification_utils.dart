import 'dart:io';
import 'dart:typed_data';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static final NotificationUtils _singleton = new NotificationUtils._internal();

  factory NotificationUtils() {
    return _singleton;
  }

  NotificationUtils._internal() {
    _initPlugin();
  }

  void _initPlugin() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future scheduleNotification() async {
    _scheduleNotification();
  }

  void cancelNotificationIfAny() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  Future _scheduleNotification() async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 10));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'mipmap/ic_launcher',
      vibrationPattern: vibrationPattern,
      color: Colors.amberAccent,
    );

    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        1, // id
        'Shortly',
        'Tap to start shortening URLs',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'ihr://play/live/1');
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);

      if (Platform.isAndroid) {
        AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
//          data: "https://play.google.com/apps/testing/com.ekocaman.shortly",
          package: "com.ekocaman.shortly",
        );
        await intent.launch();
      }
    }
  }
}
