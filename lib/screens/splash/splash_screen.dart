import 'package:flutter/material.dart';
import 'package:quizt_flutter/app.dart';
import 'package:quizt_flutter/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // TODO: Amplify初期化・Cognito匿名サインイン・Hive初期化（Phase 3-1）
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const App()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 64, color: AppTheme.accent),
            SizedBox(height: 16),
            Text(
              'Quizt',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AIが毎回異なる問題を出題します',
              style: TextStyle(fontSize: 14, color: AppTheme.ink3),
            ),
          ],
        ),
      ),
    );
  }
}
