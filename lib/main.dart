import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/app.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main()async {
WidgetsFlutterBinding.ensureInitialized();
tz.initializeTimeZones();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
await NotificationService().initializeNotifications();


await NotificationService().notifications
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
   
  runApp(ProviderScope(child: const MyApp()));
}

