import 'package:flutter/material.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Text('SettingsScreen', style: TextStyle(color: AppTheme.ink)),
      ),
    );
  }
}
