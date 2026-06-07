# Quizt 進捗管理

> このファイルはClaude Codeがセッション開始時に必ず読み、完了時に必ず更新する。

---

## 🎯 現在地

**Phase 3-2：HomeScreen 実装**

---

## ⏭ 次のアクション

`lib/screens/home/home_screen.dart` に statsProvider・StreakHeroCard・DailyProgressCard・問題を解くボタンを実装する。

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
- [x] 2-6 AppTheme（デザイントークン）クラス作成
- [x] 2-7 ナビゲーション骨格（BottomTab + 空画面）
    - [x] `flutter analyze lib/` がエラーなし
- [x] 2-8 iOSシミュレーターで起動確認
    - [x] ⚠️ シミュレーターで起動・4タブが表示されるか目視確認
    - [x] ⚠️ タブ切り替えが動くか目視確認

### Phase 3｜画面単位で縦切り実装

> 1画面 = UI表示 + ロジック + Hive保存 まで完成させてから次へ進む

- [x] 3-1 SplashScreen（Amplify初期化・Cognito匿名認証・Hive初期化）
    - [x] `flutter analyze lib/screens/splash_screen.dart` がエラーなし
    - [x] ⚠️ 起動→HomeScreen自動遷移するか目視確認
    - [x] ⚠️ Android Studioコンソールにエラーログが出ていないか確認
- [ ] 3-2 HomeScreen（statsProvider・StreakHeroCard・DailyProgressCard・問題を解くボタン）
    - [ ] `flutter analyze lib/screens/home_screen.dart` がエラーなし
    - [ ] ⚠️ StreakHeroCard・DailyProgressCard・統計カードが表示されるか目視確認
    - [ ] ⚠️ 「問題を解く」ボタンが表示されるか目視確認
    - [ ] ⚠️ `quizt_mockup.html` の画面1と見比べてUIがOKか
- [ ] 3-3 QuizScreen（API呼び出し・Cognito JWT付与・問題表示・選択肢状態管理）
    - [ ] `flutter analyze lib/screens/quiz_screen.dart` がエラーなし
    - [ ] ⚠️ Lambdaから問題が取得できるか確認（コンソールでAPIレスポンス確認）
    - [ ] ⚠️ 選択肢タップで選択中状態になるか目視確認
    - [ ] ⚠️ 「回答する」ボタンが動いてExplainScreenへ遷移するか確認
    - [ ] ⚠️ `quizt_mockup.html` の画面2と見比べてUIがOKか
- [ ] 3-4 ExplainScreen（正誤表示・Hive保存・GoalModal）
    - [ ] `flutter analyze lib/screens/explain_screen.dart` がエラーなし
    - [ ] ⚠️ 正解・不正解それぞれのResultBannerが表示されるか確認
    - [ ] ⚠️ Hive保存確認（5問解いた後にHistoryScreenで履歴が出るか）
    - [ ] ⚠️ daily_goal達成時にGoalModalが表示されるか確認
    - [ ] ⚠️ `quizt_mockup.html` の画面3・4と見比べてUIがOKか
- [ ] 3-5 CategoryScreen（カテゴリ一覧・カテゴリ別正答率・問題生成トリガー）
    - [ ] `flutter analyze lib/screens/category_screen.dart` がエラーなし
    - [ ] ⚠️ 7カテゴリが2列グリッドで表示されるか目視確認
    - [ ] ⚠️ カテゴリタップ→QuizScreen遷移するか確認
    - [ ] ⚠️ `quizt_mockup.html` の画面5と見比べてUIがOKか
- [ ] 3-6 FavoritesScreen（favorites_box一覧・カテゴリフィルタ・BottomSheet全文表示）
    - [ ] `flutter analyze lib/screens/favorites_screen.dart` がエラーなし
    - [ ] ⚠️ お気に入り登録した問題が一覧表示されるか確認
    - [ ] ⚠️ カードタップでBottomSheetが開くか確認
    - [ ] ⚠️ `quizt_mockup.html` の画面6と見比べてUIがOKか
- [ ] 3-7 HistoryScreen（history_box一覧・全体正答率・カテゴリ別バーチャート）
    - [ ] `flutter analyze lib/screens/history_screen.dart` がエラーなし
    - [ ] ⚠️ 回答履歴が一覧表示されるか確認
    - [ ] ⚠️ カテゴリ別バーチャートが表示されるか確認
    - [ ] ⚠️ `quizt_mockup.html` の画面7と見比べてUIがOKか
- [ ] 3-8 SettingsScreen（通知設定・daily_goal・データリセット）
    - [ ] `flutter analyze lib/screens/settings_screen.dart` がエラーなし
    - [ ] ⚠️ トグル操作がHiveに保存されるか確認（再起動後も設定が残るか）
    - [ ] ⚠️ データリセットで確認ダイアログが出るか確認
    - [ ] ⚠️ `quizt_mockup.html` の画面8と見比べてUIがOKか

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
