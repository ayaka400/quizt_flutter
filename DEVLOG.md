# Quizt 開発ログ

> 作業内容・決定事項・詰まった点・解決策をClaude Codeが追記していく。
> 新しい記録は一番上に追記する（降順）。

---

## 2026-06-07｜Phase 3-1 SplashScreen完了

### 作業内容
- Amplify初期化・Cognito匿名サインイン・Hive初期化を実装
- iOS Podfile の最低バージョンを 12.0 → 13.0 に変更（amplify_auth_cognitoの要件）
- amplifyconfiguration.dart のJSON内コメントを削除（FormatExceptionの原因）
- signUp成功後に資格情報を保存するよう修正（失敗時の不正データ残留バグ修正）

### 詰まった点と解決策
- **iOS 12.0エラー**: Podfileの `platform :ios, '12.0'` のコメントを外して13.0に変更
- **JSONパースエラー**: amplifyconfiguration.dartのJSON文字列内に `//` コメントが残っていた → 削除
- **SignUp not permitted**: Cognitoのセルフサービスサインアップが無効 → AWSコンソールで有効化
- **Lambda構文エラー**: Pre sign-upトリガーのPythonコードのインデントエラー → 修正・Deploy
- **Incorrect username or password**: autoVerifyEmail:Trueが原因と判断 → Lambdaから削除・アプリ再インストール

### 最終確認結果
- エラーログなしで起動 ✅
- SplashScreen → HomeScreen（BottomTab）自動遷移 ✅
- BottomTabのナビゲーション動作 ✅

---

## 2026-06-07｜Cognito認証設計の整理（外部AI分析）

### 現在の設定内容
- セルフサービスのサインアップ：**有効**
- 属性検証・アカウント確認メッセージ：**自動送信しない**
- 必須属性：**なし**

### 採用している認証方式：「サイレントサインアップ」
AWSの正式な「匿名認証（Guest Access）」はIdentity Poolを指すが、今回はUser PoolのJWTをLambdaで検証する設計のため、アプリ側で裏側に自動サインアップ・サインインを行う方式を採用している。
- 初回起動時: ランダムなユーザーID/パスワードを生成
- `Amplify.Auth.signUp()` を裏側で実行
- そのまま `Amplify.Auth.signIn()` を実行
- 取得したJWTをLambdaのAuthorizationヘッダーに付与

### MVPとしての評価
- ✅ LambdaをJWT必須にすることでBot・直接攻撃を防げる
- ✅ ユーザーは何もしなくてもクイズを即開始できる
- ⚠️ セルフサインアップ有効のためBotによるユーザー大量生成リスクあり → Billingアラートで監視

### 実装時の注意点（ハマりやすい点）
`signUp`後にユーザーが `UNCONFIRMED`（未確認）状態になる場合、`signIn`が `UserNotConfirmedException` で失敗する。
- **解決策A（推奨）**: Lambda Post Confirmationトリガーでサインアップ直後に自動CONFIRMED化
- **解決策B**: Cognitoの「アカウント確認」設定で自動確認済みになるよう調整

現時点でこのエラーが出た場合は、Cognito側の確認設定を見直す。

### 設計方針の結論
「ユーザープールを使ったサイレント認証」はPhase 3での正式アカウント移行（メール登録など）への拡張性が高く、Quiztのロードマップに合っている。このまま進めてよい。

---

## 2026-06-07｜Phase 2-7〜2-8

### 作業内容
- `lib/app.dart` 作成（BottomTab ナビゲーター・4タブ）
- `lib/main.dart` 更新（ProviderScope + AppTheme 適用・SplashScreen を起点に設定）
- 空画面6枚作成（splash / home / category / favorites / history / settings）
- `flutter analyze lib/` → エラーなし確認
- iOSシミュレーター（iPhone 17 Pro）で起動確認

### 目視確認結果
- スプラッシュ画面表示 ✅
- 1.5秒後に BottomTab 画面へ遷移 ✅
- 4タブ表示 ✅
- タブ切り替え動作 ✅

### 詰まった点
- なし

---

## 2026-06-07｜Phase 2-6

### 作業内容
- `lib/theme/app_theme.dart` 作成
- カラー12色・スペーシング2種・角丸4種をCLAUDE.mdのデザイントークン通りに定義
- `ThemeData`（scaffoldBackgroundColor・AppBarTheme・ColorScheme）を設定

### 詰まった点
- なし

---

## 2026-06-07｜Phase 2-4〜2-5

### 作業内容
- `lib/models/favorite.dart` 作成（@HiveType typeId:0、9フィールド）
- `lib/models/history_entry.dart` 作成（@HiveType typeId:1、7フィールド）
- `flutter pub run build_runner build --delete-conflicting-outputs` 実行
- `favorite.g.dart` / `history_entry.g.dart`（TypeAdapter）の自動生成を確認

### 詰まった点
- なし（7秒でビルド完了）

### 決定事項
- フィールド番号（@HiveField）は一度決めたら変更・削除禁止（既存データ破壊のリスク）
- 追加は末尾に番号を増やす形でOK

---

## 2026-06-07｜Phase 2-2〜2-3

### 作業内容
- pubspec.yaml に依存関係を追加・`flutter pub get` 完了
- `lib/amplifyconfiguration.dart` を手書きで作成

### 追加した主な依存関係
```yaml
# 本番依存
flutter_riverpod: ^2.5.1
amplify_flutter: ^2.5.0
amplify_auth_cognito: ^2.5.0
hive: ^2.2.3
hive_flutter: ^1.1.0
flutter_local_notifications: ^17.2.2
timezone: ^0.9.4
http: ^1.2.1

# 開発依存
build_runner: ^2.4.9
hive_generator: ^2.0.1
riverpod_generator: ^2.4.3
```

### 決定事項
- Amplify CLIは不使用。amplifyconfiguration.dartをCLIなしで手書き作成する方針に確定。
- amplifyconfiguration.dartはCLAUDE.mdの除外ファイルに指定（IDの混入防止）
- Lambda URLは `--dart-define` + `Makefile` で管理する（.gitignore対象）
- amplifyconfiguration.dartの.gitignore追加はお好みで（秘密鍵ではないため必須ではない）

### amplify_flutterパッケージを使う理由（確認済み）
- Cognitoの匿名認証にはSRP認証・JWT管理・リフレッシュ処理が必要
- amplify_flutterがこれらを数行で代替する
- 追加料金はゼロ（ローカルで動くDartライブラリ）
- CLIとパッケージは完全に別物（CLIなしでパッケージだけ使うのは普通）

---

## 2026-06-01｜Phase 1 完了

### 作業内容
- Cognitoユーザープール・アプリクライアント作成完了
- Lambda関数・Layer・環境変数設定完了
- JWT検証コード実装完了
- Bedrockプロンプト実装完了
- curlでJWTなし→401、JWTあり→200確認 → Phase 1完了

### 詰まった点と解決策
- **Lambda Layer**: Mac上でビルドすると動かない（cryptographyがC拡張バイナリ）
  → AWS CloudShellでビルドして解決
- **BedrockモデルID**: on-demand形式（anthropic.claude-xxx）では東京リージョン使用不可
  → 推論プロファイル形式 `global.anthropic.claude-haiku-4-5-20251001-v1:0` を使用
- **Cognitoサインイン識別子**: バリデーション上「メールアドレス」選択が必要
  → 実際の匿名認証では使用しない

### 重要な設計決定
- IDプールは不要と判明。Flutter→Lambda→Bedrockの構成ではLambdaのIAMロールが
  Bedrockを呼ぶため、フロント側にAWS権限不要。IDプールは作成済みだが使用しない。

---

## 2026-05-31｜Phase 0 完了

### 作業内容
- マスタードキュメント作成
- UIモックアップ（全9画面）HTML版を作成・完了（quizt_mockup.html）
- Xcode・Flutter SDK・CocoaPodsインストール完了
- Flutterプロジェクト作成完了（Android Studioで quizt_flutter）
- CLAUDE.md作成（quizt_flutter用・quizt_lambda用）

### 詰まった点と解決策
- **CocoaPods**: rbenv Ruby 3.2.6とactivesupportの非互換エラー
  → Homebrew版CocoaPodsを .zshrc の eval後に追加することで解決

### 決定事項
- 開発・テスト中のBedrockモデルはclaude-haiku（低コスト）を使用
- App Store公開前にSonnetへ切り替える
- Amplify Flutterは手書き設定で進める方針に決定
