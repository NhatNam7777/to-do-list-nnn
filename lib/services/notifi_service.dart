// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  // static final onNotifications = BehaviorSubject<String?>();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationsDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        // 'channel description',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final IOS = DarwinInitializationSettings();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android, iOS: IOS);
    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: ((details) async {
      onNotifications.add(details.payload);
    }));
  }

  static Future showNotification(
          {int id = 0,
          String? title,
          String? body,
          // NotificationResponse? payLoad,
          String? payLoad}) async =>
      _notifications.show(id, title, body, await _notificationsDetails(),
          payload: payLoad);

  static void showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    // NotificationResponse? payLoad,
    required DateTime scheduleDate,
    String? payLoad,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        //Thứ tự đặt 2 dòng dưới cũng quan trọng, đặt ngược lại nó xảy ra lỗi
        tz.TZDateTime.from(scheduleDate, tz.local),
        await _notificationsDetails(),
        payload: payLoad,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
}
