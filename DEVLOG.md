# Quizt 開発ログ

> 作業内容・決定事項・詰まった点・解決策をClaude Codeが追記していく。
> 新しい記録は一番上に追記する（降順）。

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
