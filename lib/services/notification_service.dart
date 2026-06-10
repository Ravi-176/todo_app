import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService{
  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
  Future<void> initializeNotifications()async{
    const AndroidInitializationSettings settingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const InitializationSettings settings = InitializationSettings(
      android:settingsAndroid,
    );
    await notifications.initialize(settings: settings);
  }
  Future<void> init()async{
    tz.initializeTimeZones();
    await notifications.initialize(settings: const InitializationSettings(
      android:AndroidInitializationSettings("@mipmap/ic_launcher"),
    ));
  }
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  })async{
  
    await notifications.zonedSchedule(
      id: id,
      title:title,
      body:body,
      scheduledDate:tz.TZDateTime.from(scheduledTime,tz.local),
      notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'todo_channel',
        'Task Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode:
      AndroidScheduleMode.inexactAllowWhileIdle,    
   );
  
  }
  Future<void> showTestNotification() async {
  await notifications.show(
    id:999,
    
    title:'Test Notification',
    body:'If you see this, notifications work',
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'todo_channel',
        'Task Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}
}