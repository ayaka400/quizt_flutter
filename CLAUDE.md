# Quizt - Flutter プロジェクト

## アプリ概要
ITエンジニア向け学習クイズアプリ。Amazon BedrockがAI問題を生成する。
iOSのみ対応（MVP）。

## アーキテクチャ
Flutter + Hive（ローカルDB） + Riverpod（状態管理）
+ Amplify Flutter（Cognito匿名認証）+ Lambda Function URL
  サーバーはステートレス。状態（履歴・お気に入り・統計）はすべてHiveに保持。

## デザイントークン（AppThemeクラスに定数として定義する）

### カラー
bg:          #F7F6F2   // 画面背景
surface:     #FFFFFF   // カード・シート背景
surface2:    #F1EFE9   // 非アクティブ要素の背景
ink:         #1A1714   // メインテキスト
ink2:        #4A4540   // サブテキスト
ink3:        #8A847D   // プレースホルダー・ラベル
ink4:        #C5BEB5   // 非アクティブアイコン
line:        #ECE8E0   // 薄いボーダー
accent:      #6C5CE7   // メインアクセント（パープル）
accentSoft:  #ECE9FF   // アクセントの薄い背景
success:     #2EC27E   // 正解・成功
danger:      #E0535B   // 不正解・エラー

### スペーシング・角丸
screenPadding: 24px   // 画面横パディング
cardPadding:   20px   // カード内パディング
rSm:           10px   // 小角丸（チップ・バッジ）
rMd:           14px   // 中角丸（ボタン）
rLg:           20px   // 大角丸（カード）
rXl:           28px   // 特大角丸（モーダル・ヒーローカード）

## 画面一覧（9画面）
0. SplashScreen  - 起動時のみ（ボトムタブなし）
1. HomeScreen    - ホーム（house）
2. QuizScreen    - 問題出題中（push遷移）
3. ExplainScreen - 解説（push遷移）
4. GoalModal     - 5問達成モーダル（オーバーレイ）
5. CategoryScreen  - カテゴリ選択（grid）
6. FavoritesScreen - お気に入り（heart）
7. HistoryScreen   - 履歴（clock）
8. SettingsScreen  - 設定（ホーム右上の歯車）

## Hive Box設計

### Box一覧
- favorites : FavoriteAdapter (typeId:0) / 上限なし
- history   : HistoryEntryAdapter (typeId:1) / 500件上限（超えたら最古から削除）
- settings  : TypeAdapter不要（Map）
- stats     : TypeAdapter不要（Map）

### settings_box キー
daily_goal:      int   デフォルト:5       // 1日の目標問題数
notify_morning:  bool  デフォルト:true    // 朝7時の通知ON/OFF
notify_evening:  bool  デフォルト:true    // 夜21時の通知ON/OFF
recent_topics:   Map   デフォルト:{}      // カテゴリ別・直近5トピック（exclude_topics用）

### stats_box キー
streak:            int    初期値:0   // 現在の連続達成日数
streak_last_date:  String 初期値:''  // 最後に目標達成した日付（例: 2026-05-02）
today_count:       int    初期値:0   // 今日解いた問題数
today_date:        String 初期値:''  // 今日の日付（日付変更検知用）
total_count:       int    初期値:0   // 累計解答数
correct_count:     int    初期値:0   // 累計正解数
category_stats:    Map    初期値:{}  // { id: {total, correct} }

### Favoriteフィールド
0: id           String        // questionのSHA256先頭16文字（重複チェック用キー）
1: question     String        // 問題文
2: choices      List<String>  // 四択の選択肢（4件）
3: answer       String        // 正解テキスト
4: explanation  String        // 解説文（200〜300字）
5: furtherStudy String        // 「〇〇についても調べてみてください。」
6: topic        String        // トピック名（例: TLS/HTTPS）
7: category     String        // カテゴリID（例: network）
8: savedAt      DateTime      // お気に入り登録日時

### HistoryEntryフィールド
0: isCorrect  bool          // 正解かどうか
1: category   String        // カテゴリID
2: topic      String        // トピック名
3: answeredAt DateTime      // 回答日時
4: question   String        // 問題文（Phase 2 復習モード用）
5: choices    List<String>  // 四択の選択肢（Phase 2 復習モード用）
6: answer     String        // 正解テキスト（Phase 2 復習モード用）

## Riverpod Provider構成

| Provider名        | 種類              | 管理する状態                         |
|-------------------|-------------------|--------------------------------------|
| quizProvider      | StateNotifier     | 現在の問題・選択肢・ローディング・達成フラグ |
| statsProvider     | StateNotifier     | streak・today_count・正答率          |
| favoritesProvider | StateNotifier     | お気に入り一覧                       |
| historyProvider   | Provider（読み取り専用） | 履歴一覧                       |

### 画面とProviderの参照関係
HomeScreen     → statsProvider, quizProvider
QuizScreen     → quizProvider, favoritesProvider
ExplainScreen  → quizProvider, statsProvider, favoritesProvider
CategoryScreen → statsProvider, quizProvider
FavoritesScreen → favoritesProvider
HistoryScreen  → historyProvider, statsProvider
SettingsScreen → settings_boxを直接読み書き（Providerなし）

## カテゴリ定義
network:     ネットワーク基礎    // TCP/IP, HTTP/HTTPS, DNS, TLS, ロードバランサーなど
os:          OS・Linux          // プロセス管理, ファイルシステム, パーミッション, シェルコマンド
security:    セキュリティ        // 認証・認可, 暗号化, 主要脆弱性（OWASP）, ベストプラクティス
db:          データベース        // RDB/NoSQL, インデックス, トランザクション, SQL
cloud:       クラウド・インフラ  // AWS/GCP基礎, IaC, コンテナ（Docker/k8s）, CI/CD
programming: プログラミング基礎  // アルゴリズム, データ構造, 計算量, 設計パターン
dev:         開発プロセス        // Git, アジャイル・スクラム, テスト手法, コードレビュー

## API仕様

### エンドポイント
POST https://xxxxxxxxxx.lambda-url.ap-northeast-1.on.aws
認証: Bearer JWT（Cognito匿名認証トークン）
タイムアウト: 30秒

### リクエスト
{
"category": "network",        // カテゴリID
"exclude_topics": ["TLS/HTTPS", "DNS"]  // 直近5件。空配列可
}

### レスポンス（200 OK）
{
"question":     "問題文",
"format":       "choice",
"choices":      ["A", "B", "C", "D"],
"answer":       "正解テキスト",
"explanation":  "解説文（200〜300字）",
"further_study": "〇〇についても調べてみてください。",
"topic":        "TLS/HTTPS"
}

### エラー処理
401 → 「認証エラーが発生しました。アプリを再起動してください。」
400 → 「データの読み込みに失敗しました。もう一度試してください。」
500 → 「問題の取得に失敗しました。しばらくお待ちください。」
タイムアウト → 「接続がタイムアウトしました。もう一度試してください。」
通信不可 → 「インターネット接続を確認してください。」

## 認証フロー（Amplify Flutter + Cognito匿名認証）
1. SplashScreen起動時にAmplify.Auth.signInWithWebUI(guest)
2. CognitoがJWTを発行・Amplifyが自動キャッシュ・自動更新（1時間）
3. API呼び出し時: fetchAuthSession → accessToken.raw → Authorizationヘッダーに付与

## ローカル通知
ID:1 毎日7:00  タイトル:「☀️ 今日の朝のクイズ」 本文:「今日も5問チャレンジしよう！」
ID:2 毎日21:00 タイトル:「🌙 今日の夜のクイズ」 本文:「1日の締めくくりに学習しよう。」
登録タイミング: 初回起動時・設定変更時

## ストリーク更新ロジック
- today_count == daily_goal かつ streak_last_date != 今日 → streak++ / streak_last_date更新
- today_count == daily_goal かつ streak_last_date == 今日 → 何もしない
- 起動時に today_date != 今日 → today_count = 0 にリセット
- 起動時に streak_last_date が昨日でも今日でもない → streak = 0 にリセット

## 現在の実装状況
（都度更新する）
- [x] Phase 0: 準備完了（モックアップ・環境構築・CLAUDE.md）
- [ ] Phase 1: AWSバックエンド完成
- [ ] Phase 2: Flutter基盤（pubspec / AppTheme / Hiveモデル / Provider骨格）
- [ ] Phase 3-1: SplashScreen
- [ ] Phase 3-2: HomeScreen
- [ ] Phase 3-3: QuizScreen
- [ ] Phase 3-4: ExplainScreen
- [ ] Phase 3-5: CategoryScreen
- [ ] Phase 3-6: FavoritesScreen
- [ ] Phase 3-7: HistoryScreen
- [ ] Phase 3-8: SettingsScreen
- [ ] Phase 4: 仕上げ・エッジケース
- [ ] Phase 5: 申請準備