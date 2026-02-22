import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/restaurant.dart';
import '../services/restaurant_api_service.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'daily_reminder_channel',
        'Daily Reminder',
        description: 'Restaurant recommendation reminder',
        importance: Importance.max,
      ),
    );
  }

  static Future<void> showDailyReminderNotification() async {
    try {
      final apiService = RestaurantApiService();
      final restaurants = await apiService.getRestaurantList();

      if (restaurants.isEmpty) {
        return;
      }

      final random = Random();
      final Restaurant restaurant =
          restaurants[random.nextInt(restaurants.length)];

      const androidDetails = AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminder',
        channelDescription: 'Restaurant recommendation reminder',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        autoCancel: true,
        ongoing: false,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.show(
        0,
        'Restaurant Recommendation',
        '${restaurant.name} di ${restaurant.city} — ⭐ ${restaurant.rating}. Yuk makan siang!',
        notificationDetails,
        payload: restaurant.id,
      );
    } catch (e) {
      const androidDetails = AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminder',
        channelDescription: 'Restaurant recommendation reminder',
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: true,
        ongoing: false,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _plugin.show(
        0,
        'Lunch Reminder',
        'Jangan lupa makan siang! Cek restoran favorit kamu.',
        notificationDetails,
      );
    }
  }

  static Duration calculateInitialDelay() {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);

    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime.difference(now);
  }
}
