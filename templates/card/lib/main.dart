// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'app_lifecycle/app_lifecycle.dart';
import 'audio/audio_controller.dart';
import 'player_progress/player_progress.dart';
import 'router.dart';
import 'settings/settings.dart';
import 'style/palette.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  // Basic logging setup.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Firebase.initializeApp();
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> schedulePeriodicNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel', // Channel ID
      'Reminder Notifications', // Channel name
      channelDescription: 'Notifications to remind the user every 2 minutes',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0, // Notification ID
      'Reminder', // Notification title
      'Don’t forget to check the app!', // Notification body
      RepeatInterval.everyMinute, // Repeat interval (closest to 2 minutes)
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required parameter
    );
  }

  Future<void> scheduleNotifications() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminder_channel', // Channel ID
      'Reminder Notifications', // Channel name
      channelDescription: 'Notifications to remind the user every hour',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Show the notification once upon app launch
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Welcome!', // Notification title
      'Thanks for launching the app!', // Notification body
      notificationDetails,
    );

    // Schedule hourly notifications
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1, // Notification ID
      'Reminder', // Notification title
      'Don’t forget to check the app!', // Notification body
      RepeatInterval.hourly, // Repeat interval
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required parameter
    );
  }

  @override
  Widget build(BuildContext context) {
    schedulePeriodicNotification();
    scheduleNotifications();
    return AppLifecycleObserver(
      child: MultiProvider(
        // This is where you add objects that you want to have available
        // throughout your game.
        //
        // Every widget in the game can access these objects by calling
        // `context.watch()` or `context.read()`.
        // See `lib/main_menu/main_menu_screen.dart` for example usage.
        providers: [
          Provider(create: (context) => SettingsController()),
          Provider(create: (context) => Palette()),
          ChangeNotifierProvider(create: (context) => PlayerProgress()),
          // Set up audio.
          ProxyProvider2<AppLifecycleStateNotifier, SettingsController,
              AudioController>(
            create: (context) => AudioController(),
            update: (context, lifecycleNotifier, settings, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
            // Ensures that music starts immediately.
            lazy: false,
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'My Flutter Game',
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                surface: palette.backgroundMain,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: palette.ink),
              ),
              useMaterial3: true,
            ).copyWith(
              // Make buttons more fun.
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            routerConfig: router,
          );
        }),
      ),
    );
  }
}
