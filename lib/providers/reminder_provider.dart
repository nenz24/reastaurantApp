import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderProvider extends ChangeNotifier {
  static const String _key = 'daily_reminder';

  bool _isReminderEnabled = false;
  bool get isReminderEnabled => _isReminderEnabled;

  ReminderProvider() {
    loadReminder();
  }

  Future<void> loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderEnabled = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> setReminder(bool value) async {
    _isReminderEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
