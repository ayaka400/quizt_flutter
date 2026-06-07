import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizt_flutter/screens/splash/splash_screen.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: QuiztApp()));
}

class QuiztApp extends StatelessWidget {
  const QuiztApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizt',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
