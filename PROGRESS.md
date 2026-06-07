# Quizt 進捗管理

> このファイルはClaude Codeがセッション開始時に必ず読み、完了時に必ず更新する。

---

## 🎯 現在地

**Phase 2-6：AppThemeクラス作成**

---

## ⏭ 次のアクション

`lib/theme/app_theme.dart` を作成してデザイントークン定数を定義する。

---

## 📋 全タスク進捗

### Phase 1｜AWSバックエンド ✅ 完了（2026-06-01）

- [x] 1-1 Cognitoユーザープール作成
- [x] 1-2 匿名認証（Guest Access）有効化
- [x] 1-3 アプリクライアント作成・クライアントIDメモ
- [x] 1-4 Lambda関数作成（Python 3.12）
- [x] 1-5 Lambda Layer追加（PyJWT・cryptography・requests）
- [x] 1-6 Lambda環境変数設定（POOL_ID, REGION）
- [x] 1-7 JWT検証コード実装
- [x] 1-8 Bedrockプロンプト実装
- [x] 1-9 curlでJWTなし → 401確認
- [x] 1-10 curlでJWTあり → 問題JSON返却確認

### Phase 2｜Flutterプロジェクト基盤

- [x] 2-1 Flutterプロジェクト作成（Android Studioで作成済み）
- [x] 2-2 pubspec.yaml 依存関係追加
- [x] 2-3 amplifyconfiguration.dart 手書き作成
- [x] 2-4 Hiveモデル（Favorite, HistoryEntry）作成
- [x] 2-5 build_runner で TypeAdapter 自動生成
- [ ] 2-6 AppTheme（デザイントークン）クラス作成
- [ ] 2-7 ナビゲーション骨格（BottomTab + 空画面）
- [ ] 2-8 iOSシミュレーターで起動確認

### Phase 3｜画面単位で縦切り実装

> 1画面 = UI表示 + ロジック + Hive保存 まで完成させてから次へ進む

- [ ] 3-1 SplashScreen（Amplify初期化・Cognito匿名認証・Hive初期化）
- [ ] 3-2 HomeScreen（statsProvider・StreakHeroCard・DailyProgressCard・問題を解くボタン）
- [ ] 3-3 QuizScreen（API呼び出し・Cognito JWT付与・問題表示・選択肢状態管理）
- [ ] 3-4 ExplainScreen（正誤表示・Hive保存・GoalModal）
- [ ] 3-5 CategoryScreen（カテゴリ一覧・カテゴリ別正答率・問題生成トリガー）
- [ ] 3-6 FavoritesScreen（favorites_box一覧・カテゴリフィルタ・BottomSheet全文表示）
- [ ] 3-7 HistoryScreen（history_box一覧・全体正答率・カテゴリ別バーチャート）
- [ ] 3-8 SettingsScreen（通知設定・daily_goal・データリセット）

### Phase 4｜仕上げ・エッジケース

- [ ] 4-1 ローカル通知スケジュール実装（朝7時・夜21時）
- [ ] 4-2 ストリーク日付ロールオーバーロジック（checkDateRollover()）
- [ ] 4-3 エラーハンドリング全画面（401 / 500 / タイムアウト / オフライン）
- [ ] 4-4 UIの細部修正（モックアップと見比べながら調整）

### Phase 5｜申請準備

- [ ] 5-1 iOSシミュレーター全画面テスト（全9画面・全エラーケース）
- [ ] 5-2 実機テスト
- [ ] 5-3 プライバシーポリシーページ作成・公開（GitHub Pages等。AI開示・Bedrock記載必須）
- [ ] 5-4 AWS Billingアラート設定 ⚠️ 必須
- [ ] 5-5 App Store Connect設定（プライバシーラベル「データ収集なし」）
- [ ] 5-6 TestFlight配布
- [ ] 5-7 App Store審査申請

---

## 🔴 未解決の問題

なし

---

## 📝 決定事項メモ（重要なものだけ）

- Amplify CLIは不使用。amplifyconfiguration.dartを手書きで管理。
- IDプールは不要（LambdaのIAMロールがBedrockを呼ぶため、フロント側にAWS権限不要）
- BedrockモデルID: `global.anthropic.claude-haiku-4-5-20251001-v1:0`（推論プロファイル形式）
- 開発中はHaiku、App Store公開前にSonnetへ切り替える
- Lambda URLは `--dart-define=LAMBDA_URL=...` で渡す（Makefileで管理）
- `amplifyconfiguration.dart` はClaude Codeの読み込み対象外
