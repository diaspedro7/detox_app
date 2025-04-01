// ignore_for_file: avoid_print

import 'package:flutter/services.dart';

class NotifOnKill {
  static const platform = MethodChannel('appsTimeUsage');

  static Future<void> toggleNotifOnKill(bool value) async {
    try {
      if (value) {
        await platform.invokeMethod(
          'setNotificationOnKillService',
          {
            'title': "App Closed!",
            'description':
                "Keep Dopamini running in the background for monitoring.",
          },
        );
        print('NotificationOnKillService set with success');
      } else {
        await platform.invokeMethod('stopNotificationOnKillService');
        print('NotificationOnKillService stopped with success');
      }
    } catch (e) {
      print('NotificationOnKillService error: $e');
    }
  }
}
