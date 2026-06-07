import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizt_flutter/amplifyconfiguration.dart';
import 'package:quizt_flutter/app.dart';
import 'package:quizt_flutter/models/favorite.dart';
import 'package:quizt_flutter/models/history_entry.dart';
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
    try {
      await _initAmplify();
      await _initHive();
      await _signInAnonymously();
    } catch (e) {
      safePrint('SplashScreen init error: $e');
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const App()),
    );
  }

  Future<void> _initAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      // hot reload 時など既に設定済みの場合は無視
    }
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(FavoriteAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HistoryEntryAdapter());
    await Hive.openBox<Favorite>('favorites');
    await Hive.openBox<HistoryEntry>('history');
    await Hive.openBox('settings');
    await Hive.openBox('stats');
  }

  Future<void> _signInAnonymously() async {
    final session = await Amplify.Auth.fetchAuthSession();
    if (session.isSignedIn) return;

    final box = Hive.box('settings');
    var username = box.get('anon_username') as String?;
    var password = box.get('anon_password') as String?;

    if (username == null || password == null) {
      // 初回起動: 匿名ユーザーを自動生成
      username = '${_randomHex(16)}@anon.quizt.app';
      // Cognitoパスワードポリシー（大文字・小文字・数字・記号）に対応
      password = 'Qz!${_randomHex(18)}Aa1';

      // signUp成功後に保存（失敗時に不正な資格情報が残るのを防ぐ）
      await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: {AuthUserAttributeKey.email: username},
        ),
      );

      await box.put('anon_username', username);
      await box.put('anon_password', password);
    }

    await Amplify.Auth.signIn(username: username, password: password);
  }

  String _randomHex(int length) {
    final rng = Random.secure();
    return List.generate(length, (_) => rng.nextInt(16).toRadixString(16)).join();
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
