import 'package:flutter/material.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Text('HomeScreen', style: TextStyle(color: AppTheme.ink)),
      ),
    );
  }
}
