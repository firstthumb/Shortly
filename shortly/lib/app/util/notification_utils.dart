import 'dart:io';
import 'dart:typed_data';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  final String channelId = "1";
  final String channelName = "Shortly";
  final String channelDescription = "Shortly";

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
      channelId,
      channelName,
      channelDescription,
      icon: 'mipmap/ic_launcher',
      vibrationPattern: vibrationPattern,
      color: Colors.redAccent,
      playSound: false,
    );

    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      1, // id
      'Shortly',
      'Shorten your URL',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  Future onSelectNotification(String payload) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: "com.ekocaman.shortly.MainActivity",
        package: "com.ekocaman.shortly",
      );
      await intent.launch();
    }
  }
}
