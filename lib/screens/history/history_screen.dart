import 'package:flutter/material.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Text('HistoryScreen', style: TextStyle(color: AppTheme.ink)),
      ),
    );
  }
}
