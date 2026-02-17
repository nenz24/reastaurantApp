import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import '../providers/theme_provider.dart';
import '../providers/reminder_provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return _SettingsTile(
                        icon: themeProvider.isDarkMode
                            ? CupertinoIcons.moon_fill
                            : CupertinoIcons.sun_max_fill,
                        iconColor: themeProvider.isDarkMode
                            ? Colors.indigo
                            : Colors.orange,
                        title: 'Dark Mode',
                        subtitle: themeProvider.isDarkMode
                            ? 'Dark theme active'
                            : 'Light theme active',
                        trailing: Switch.adaptive(
                          value: themeProvider.isDarkMode,
                          onChanged: (_) => themeProvider.toggleTheme(),
                          activeTrackColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  Consumer<ReminderProvider>(
                    builder: (context, reminderProvider, child) {
                      return _SettingsTile(
                        icon: CupertinoIcons.bell_fill,
                        iconColor: Colors.redAccent,
                        title: 'Restaurant Notification',
                        subtitle: reminderProvider.isReminderEnabled
                            ? 'Enabled — daily at 11:00 AM'
                            : 'Disabled',
                        trailing: Switch.adaptive(
                          value: reminderProvider.isReminderEnabled,
                          onChanged: (value) async {
                            if (value) {
                              final status = await Permission.notification
                                  .request();

                              if (!status.isGranted) {
                                if (context.mounted) {
                                  _showPermissionAlert(context);
                                }
                                return;
                              }

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pengingat harian dijadwalkan pukul 11:00 AM',
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            }

                            await reminderProvider.setReminder(value);
                            if (value) {
                              await Workmanager().registerPeriodicTask(
                                'daily_reminder',
                                'dailyReminder',
                                frequency: const Duration(hours: 24),
                                initialDelay: _calculateInitialDelay(),
                                existingWorkPolicy:
                                    ExistingPeriodicWorkPolicy.replace,
                              );
                            } else {
                              await Workmanager().cancelByUniqueName(
                                'daily_reminder',
                              );
                            }
                          },
                          activeTrackColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);

    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime.difference(now);
  }

  void _showPermissionAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Notification permission is permanently denied. Please enable it in the app settings to use the reminder feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
