# Quizt - Flutter プロジェクト

> ITエンジニア向け学習クイズアプリ。Amazon BedrockがAI問題を生成する。iOSのみ対応（MVP）。

---

## ⚡ セッション開始時に必ずやること（最重要）

1. `PROGRESS.md` を読んで現在地と次のアクションを把握する
2. `DEVLOG.md` の直近10行を読んで前回の作業を把握する
3. 「現在地：〇〇、次のアクション：〇〇」を一言で返してから作業を始める

## ✅ 作業完了時に必ずやること

1. `PROGRESS.md` の該当タスクを `[ ]` → `[x]` に更新する
2. 「次のアクション」セクションを更新する
3. `DEVLOG.md` に今日の作業内容・決定事項・詰まった点を追記する

## 🚫 ファイル操作のルール

- `lib/amplifyconfiguration.dart` は読み込まない（AWSリソースIDが含まれる）
- `Makefile` は読み込まない（Lambda URLが含まれる）
- シークレット類は絶対にコードにハードコードしない
- Lambda URLは `String.fromEnvironment('LAMBDA_URL')` で参照する

---

## アーキテクチャ

```
Flutter (iOS)
├ UI Layer        : 9画面 + 共通Widget
├ State           : Riverpod (StateNotifierProvider)
├ Auth            : Amplify Flutter → Cognito匿名認証 → JWT取得・自動更新
├ Local DB        : Hive (favorites / history / settings / stats)
└ Notify          : flutter_local_notifications

        │ HTTPS  Authorization: Bearer {JWT}

AWS Lambda (Python 3.12)
└ JWT検証 → プロンプト組み立て → Bedrock呼び出し → JSON返却

Amazon Bedrock (Claude Haiku)
└ global.anthropic.claude-haiku-4-5-20251001-v1:0
  ※ App Store公開前にSonnetへ切り替える
```

---

## デザイントークン（AppTheme クラスで定義）

### カラー
| トークン    | 値        | 用途                     |
|------------|----------|--------------------------|
| bg         | #F7F6F2  | 画面背景                  |
| surface    | #FFFFFF  | カード・シート背景          |
| surface2   | #F1EFE9  | 非アクティブ要素の背景      |
| ink        | #1A1714  | メインテキスト              |
| ink2       | #4A4540  | サブテキスト               |
| ink3       | #8A847D  | プレースホルダー・ラベル    |
| ink4       | #C5BEB5  | 非アクティブアイコン        |
| line       | #ECE8E0  | 薄いボーダー               |
| accent     | #6C5CE7  | メインアクセント（パープル） |
| accentSoft | #ECE9FF  | アクセントの薄い背景        |
| success    | #2EC27E  | 正解・成功                 |
| danger     | #E0535B  | 不正解・エラー              |

### スペーシング・角丸
| トークン       | 値   | 用途                    |
|--------------|------|------------------------|
| screenPadding | 24px | 画面横パディング          |
| cardPadding   | 20px | カード内パディング         |
| rSm           | 10px | 小角丸（チップ・バッジ）   |
| rMd           | 14px | 中角丸（ボタン）           |
| rLg           | 20px | 大角丸（カード）           |
| rXl           | 28px | 特大角丸（モーダル等）     |

---

## Hive Box 設計

| Box名     | TypeAdapter             | TypeId | 上限   | 役割                        |
|-----------|------------------------|--------|--------|----------------------------|
| favorites | FavoriteAdapter        | 0      | なし   | お気に入り問題の永続ストア     |
| history   | HistoryEntryAdapter    | 1      | 500件  | 回答履歴ログ（古いものから削除）|
| settings  | なし（動的Map）          | -      | -      | 設定値・recent_topics        |
| stats     | なし（動的Map）          | -      | -      | 学習統計の集計済みデータ       |

### settings_box キー
- `daily_goal` : int, デフォルト5
- `notify_morning` : bool, デフォルトtrue
- `notify_evening` : bool, デフォルトtrue
- `recent_topics` : Map, カテゴリ別・直近5トピック（exclude_topics用）

### stats_box キー
- `streak` : int
- `streak_last_date` : String（例: "2026-06-07"）
- `today_count` : int
- `today_date` : String
- `total_count` : int
- `correct_count` : int
- `category_stats` : Map { id: {total, correct} }

### Favorite フィールド（typeId:0）
| # | フィールド名  | 型            | 説明                              |
|---|-------------|--------------|----------------------------------|
| 0 | id          | String       | questionのSHA256先頭16文字         |
| 1 | question    | String       | 問題文                            |
| 2 | choices     | List<String> | 四択の選択肢（4件）                |
| 3 | answer      | String       | 正解テキスト                       |
| 4 | explanation | String       | 解説文（200〜300字）               |
| 5 | furtherStudy| String       | 「〇〇についても調べてみてください。」|
| 6 | topic       | String       | トピック名（例: TLS/HTTPS）         |
| 7 | category    | String       | カテゴリID（例: network）          |
| 8 | savedAt     | DateTime     | お気に入り登録日時                  |

### HistoryEntry フィールド（typeId:1）
| # | フィールド名  | 型            | 説明                              |
|---|-------------|--------------|----------------------------------|
| 0 | isCorrect   | bool         | 正解かどうか                       |
| 1 | category    | String       | カテゴリID                        |
| 2 | topic       | String       | トピック名                         |
| 3 | answeredAt  | DateTime     | 回答日時                           |
| 4 | question    | String       | 問題文（Phase 2復習モード用）        |
| 5 | choices     | List<String> | 四択（Phase 2復習モード用）          |
| 6 | answer      | String       | 正解テキスト（Phase 2復習モード用）   |

---

## Riverpod Provider 構成

| Provider名        | 種類          | 管理する状態                              |
|------------------|--------------|------------------------------------------|
| quizProvider     | StateNotifier | 現在の問題・選択肢・ローディング・達成フラグ |
| statsProvider    | StateNotifier | streak・today_count・正答率               |
| favoritesProvider| StateNotifier | お気に入り一覧                             |
| historyProvider  | Provider      | 履歴一覧（読み取り専用）                   |

### 画面とProviderの参照関係
| 画面             | 参照するProvider                              |
|-----------------|----------------------------------------------|
| HomeScreen       | statsProvider, quizProvider                  |
| QuizScreen       | quizProvider, favoritesProvider              |
| ExplainScreen    | quizProvider, statsProvider, favoritesProvider|
| CategoryScreen   | statsProvider, quizProvider                  |
| FavoritesScreen  | favoritesProvider                            |
| HistoryScreen    | historyProvider, statsProvider               |
| SettingsScreen   | settings_boxを直接読み書き（Providerなし）     |

---

## カテゴリ定義

| ID          | 名前             | 説明                                              |
|-------------|----------------|--------------------------------------------------|
| network     | ネットワーク基礎  | TCP/IP, HTTP/HTTPS, DNS, TLS, ロードバランサーなど |
| os          | OS・Linux       | プロセス管理, ファイルシステム, パーミッション        |
| security    | セキュリティ      | 認証・認可, 暗号化, OWASP, ベストプラクティス        |
| db          | データベース      | RDB/NoSQL, インデックス, トランザクション, SQL       |
| cloud       | クラウド・インフラ | AWS/GCP基礎, IaC, Docker/k8s, CI/CD              |
| programming | プログラミング基礎 | アルゴリズム, データ構造, 計算量, 設計パターン       |
| dev         | 開発プロセス      | Git, アジャイル, テスト手法, コードレビュー          |

---

## 画面一覧

| # | 画面ID          | 画面名          | ボトムタブ              |
|---|----------------|----------------|------------------------|
| 0 | SplashScreen   | スプラッシュ     | なし（起動時のみ）       |
| 1 | HomeScreen     | ホーム          | ホーム（house）          |
| 2 | QuizScreen     | 問題（出題中）   | なし（push遷移）         |
| 3 | ExplainScreen  | 問題（解説）    | なし（push遷移）         |
| 4 | GoalModal      | 5問達成モーダル  | なし（オーバーレイ）     |
| 5 | CategoryScreen | カテゴリを選ぶ  | カテゴリを選ぶ（grid）   |
| 6 | FavoritesScreen| お気に入り       | お気に入り（heart）      |
| 7 | HistoryScreen  | 履歴            | 履歴（clock）            |
| 8 | SettingsScreen | 設定            | なし（ホーム右上の歯車）  |

---

## 各画面の実装詳細

### SplashScreen
- 表示: アプリロゴ・アプリ名・「AIが毎回異なる問題を出題します」
- 処理: Amplify初期化 → Cognito匿名サインイン → Hive初期化 → HomeScreen遷移
- 初回のみ通知許可ダイアログを表示

### HomeScreen
| ウィジェット       | 仕様                                                            |
|-----------------|----------------------------------------------------------------|
| グリーティング    | 日付(ink3・13px) + 時間帯別挨拶（おはよう☀️/こんにちは🌤/お疲れ🌙） |
| StreakHeroCard   | accentグラデーション背景。ストリーク日数64px・800。曜日ドット付き  |
| DailyProgressCard| 今日の目標・あとN問でクリア・5本プログレスバー（達成分はaccent）  |
| 問題を解くボタン  | h:58px。未達成:accent背景 / 達成済み:accentSoft背景             |
| 統計カード       | 正答率（トロフィー）と解答数（本アイコン）を2カラムで表示          |

### QuizScreen
| ウィジェット    | 仕様                                                                    |
|--------------|------------------------------------------------------------------------|
| トップバー    | 左:×ボタン（ホームに戻る） 右:ハートボタン（お気に入り登録）               |
| カテゴリバッジ | 36x36pxアイコンボックス（絵文字）+ カテゴリ名 + トピック名               |
| 問題カード    | surface背景・rXl角丸。問題文 fontSize:20・fontWeight:700                |
| ChoiceCard×4 | 状態: 通常(line border) / 選択中(accent+accentSoft) / 正解 / 不正解     |
| 回答ボタン    | 選択肢未選択時はdisabled。押下でExplainScreenへ遷移                      |

### ExplainScreen
| ウィジェット     | 仕様                                                               |
|---------------|-------------------------------------------------------------------|
| ResultBanner  | 正解:accentグラデ・✓・「正解！」/ 不正解:dangerSoft・×・正解テキスト |
| 解説テキスト   | fontSize:14・lineHeight:1.75。キーワードは太字                      |
| NEXTヒント    | accentSoft背景。💡 + 「〇〇についても調べてみてください。」           |
| ボトムバー    | 左:「ホームに戻る」ghost / 右:「次の問題→」primary                  |
| GoalModal     | daily_goal達成時にオーバーレイ表示                                  |

### GoalModal
- backdrop-blur オーバーレイ上に白カード
- トロフィーアイコン（88px円形グラデ）+「今日の目標達成！」
- ストリーク日数をaccentカラーで強調
- 達成ドット（5個）+ 「ホームに戻る」/「もう少し続ける」

### CategoryScreen
- 2列グリッドに7カテゴリカード
- カテゴリ別正答率を表示
- タップ → 問題生成 → QuizScreen

### FavoritesScreen
- カテゴリフィルタータブ + カードリスト
- タップでBottomSheet全文表示

### HistoryScreen
- グラデーションカードで全体正答率
- カテゴリ別横バーチャート

### SettingsScreen
| セクション | 項目               | コントロール        | デフォルト |
|----------|------------------|-------------------|----------|
| 通知      | プッシュ通知        | トグル             | ON       |
| 通知      | 朝の通知（7:00）   | トグル             | ON       |
| 通知      | 夜の通知（21:00）  | トグル             | ON       |
| 学習      | 1日の目標          | BottomSheet(3/5/10)| 5問      |
| その他    | プライバシーポリシー | 外部リンク          | -        |
| その他    | データをリセット    | 確認ダイアログ       | -        |
| その他    | バージョン          | テキスト           | 1.0.0    |

---

## API仕様

- エンドポイント: Lambda Function URL（`String.fromEnvironment('LAMBDA_URL')`で参照）
- 認証: `Authorization: Bearer {JWT}`
- タイムアウト: 30秒

### リクエスト
```json
{
  "category": "network",
  "exclude_topics": ["TLS/HTTPS", "DNS"]
}
```

### レスポンス（200 OK）
```json
{
  "question": "...",
  "format": "choice",
  "choices": ["A", "B", "C", "D"],
  "answer": "A",
  "explanation": "...",
  "further_study": "〇〇についても調べてみてください。",
  "topic": "TLS/HTTPS"
}
```

### エラーレスポンス
| ステータス  | ケース           | Flutter側の表示                              |
|-----------|----------------|---------------------------------------------|
| 401       | JWT無効         | 「認証エラーが発生しました。アプリを再起動してください。」|
| 400       | リクエスト形式エラー| 「データの読み込みに失敗しました。もう一度試してください。」|
| 500       | Lambda/Bedrockエラー| 「問題の取得に失敗しました。しばらくお待ちください。」|
| タイムアウト | 30秒超過        | 「接続がタイムアウトしました。もう一度試してください。」|
| 通信不可   | ネットワーク未接続 | 「インターネット接続を確認してください。」          |

---

## ローカル通知

| ID | 時刻    | タイトル           | 本文                         |
|----|--------|-------------------|------------------------------|
| 1  | 毎日7:00 | ☀️ 今日の朝のクイズ | 今日も5問チャレンジしよう！     |
| 2  | 毎日21:00| 🌙 今日の夜のクイズ | 1日の締めくくりに学習しよう。   |

- 登録タイミング: 初回起動時・設定変更時
- タップ時: アプリ起動 → QuizScreen

---

## AWSリソース（Phase 1完了時点）

※ 実際の値はamplifyconfiguration.dartとMakefileで管理。ここには書かない。

| リソース              | メモ                                        |
|--------------------|---------------------------------------------|
| Cognitoユーザープール | quizt-user-pool / ap-northeast-1            |
| Lambdaタイムアウト    | 30秒                                        |
| BedrockモデルID      | global.anthropic.claude-haiku-4-5-20251001-v1:0 |
| Lambda Layer        | quizt-jwt-layer-v3（PyJWT・cryptography・requests）|
| IDプール             | 不要（作成済みだが使用しない）               |

---

## ディレクトリ構成（予定）

```
lib/
├ main.dart
├ amplifyconfiguration.dart   ← Claude Code読み込み対象外
├ config/
│   └ app_config.dart         ← LAMBDA_URLをfromEnvironmentで参照
├ theme/
│   └ app_theme.dart          ← デザイントークン定数
├ models/
│   ├ favorite.dart
│   ├ favorite.g.dart         ← build_runner自動生成
│   ├ history_entry.dart
│   └ history_entry.g.dart    ← build_runner自動生成
├ providers/
│   ├ quiz_provider.dart
│   ├ stats_provider.dart
│   ├ favorites_provider.dart
│   └ history_provider.dart
├ services/
│   ├ api_service.dart        ← Lambda呼び出し・JWT付与
│   └ storage_service.dart    ← Hive読み書き
└ screens/
    ├ splash_screen.dart
    ├ home_screen.dart
    ├ quiz_screen.dart
    ├ explain_screen.dart
    ├ category_screen.dart
    ├ favorites_screen.dart
    ├ history_screen.dart
    └ settings_screen.dart
```