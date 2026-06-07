import 'package:flutter/material.dart';
import 'package:quizt_flutter/screens/category/category_screen.dart';
import 'package:quizt_flutter/screens/favorites/favorites_screen.dart';
import 'package:quizt_flutter/screens/history/history_screen.dart';
import 'package:quizt_flutter/screens/home/home_screen.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.ink4,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.house_rounded), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'カテゴリ'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'お気に入り'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_rounded), label: '履歴'),
        ],
      ),
    );
  }
}
