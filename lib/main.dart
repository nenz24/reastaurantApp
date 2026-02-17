import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'providers/restaurant_list_provider.dart';
import 'providers/restaurant_detail_provider.dart';
import 'providers/search_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/main_provider.dart';
import 'providers/reminder_provider.dart';
import 'themes/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/notification_helper.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'dailyReminder') {
      await NotificationHelper.init();
      await NotificationHelper.showDailyReminderNotification();
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper.init();
  await Workmanager().initialize(callbackDispatcher);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantListProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantDetailProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
