import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/main_provider.dart';
import 'restaurant_list_screen.dart';
import 'favorite_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const RestaurantListScreen(),
    const FavoriteScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        return Scaffold(
          body: _screens[mainProvider.selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: mainProvider.selectedIndex,
              onTap: (index) {
                mainProvider.setIndex(index);
              },
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).disabledColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house),
                  activeIcon: Icon(CupertinoIcons.house_fill),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart),
                  activeIcon: Icon(CupertinoIcons.heart_fill),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings),
                  activeIcon: Icon(CupertinoIcons.settings_solid),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
