import 'package:flutter/material.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Text('FavoritesScreen', style: TextStyle(color: AppTheme.ink)),
      ),
    );
  }
}
